class MezuroPlugin::ProjectContent < Article 
  validate :validate_kalibro_project_name

  def self.short_description
    'Kalibro project'
  end

  def self.description
    'Software project tracked by Kalibro'
  end

  settings_items :license, :description, :repository_type, :repository_url, :configuration_name, :periodicity_in_days

  include ActionView::Helpers::TagHelper
  def to_html(options = {})
    lambda do
      render :file => 'content_viewer/show_project.rhtml'
    end
  end
  

  def project
    @project ||= Kalibro::Client::ProjectClient.project(name)
  end

  def project_result
    @project_result ||= Kalibro::Client::ProjectResultClient.last_result(name)
  end
  
  def get_date_result(date)
    client =  Kalibro::Client::ProjectResultClient.new
    @project_result ||= client.has_results_before(name, date) ? client.last_result_before(name, date) : 
client.first_result_after(name, date)
  end

  def module_result(module_name)
    module_name = project.name if module_name.nil? 
    @module_client ||= module_result_client.module_result(project.name, module_name, project_result.date)
  end

  def result_history(module_name)
    @result_history ||= module_result_client.result_history(project.name, module_name)
  end

  after_save :send_project_to_service
  after_destroy :remove_project_from_service

  private

  def validate_kalibro_project_name
    existing = Kalibro::Client::ProjectClient.new.project_names
    
    if existing.include?(name)
      errors.add_to_base("Project name already exists in Kalibro")
    end
  end

  def send_project_to_service
    Kalibro::Client::ProjectClient.save(self)
    Kalibro::Client::KalibroClient.process_project(name, periodicity_in_days)
  end

  def remove_project_from_service
    Kalibro::Client::ProjectClient.remove(name)
  end

  def module_result_client
    @module_result_client ||= Kalibro::Client::ModuleResultClient.new
  end
end


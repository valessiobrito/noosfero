require File.dirname(__FILE__) + '/../test_helper'

class FormsHelperTest < ActiveSupport::TestCase

  include ApplicationHelper
  include FormsHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper

  should 'wrapper required fields in <span class=required-field>' do
    content = required('<input type=text name=test>')
    assert_tag_in_string content, :tag => 'span', :attributes => {:class => 'required-field'}
  end

  should 'wrapper required fields message in <span class=required-field>' do
    content = required_fields_message()
    assert_tag_in_string content, :tag => 'span', :attributes => {:class => 'required-field'}
  end

  should 'wrapper highlighted in label pseudoformlabel' do
    content = required_fields_message()
    assert_tag_in_string content, :tag => 'label', :content => 'highlighted', :attributes => {:class => 'pseudoformlabel'}
  end

  should 'show title for option in select' do
    content = options_for_select_with_title({'option_value' => 'option_title'})
    assert_tag_in_string content, :tag => 'option', :attributes => {:title => 'option_value'}
  end

  should 'add label to ordinary form fields (in labelled_form_for)' do
    def protect_against_forgery?; false; end
    def tag(name, atts, bool); "<#{name}>" end
    content = _erbout = ''
    labelled_form_for :user, User.new, :url=>'' do |f|
      content = f.text_field :login
    end
    assert_tag_in_string content, :tag => 'label'
  end

  should 'not add label to a field with placeholder (in labelled_form_for)' do
    def protect_against_forgery?; false; end
    def tag(name, atts, bool); "<#{name}>" end
    content = _erbout = ''
    labelled_form_for :user, User.new, :url=>'' do |f|
      content = f.text_field :login, :placeholder => 'login'
    end
    assert_no_tag_in_string content, :tag => 'label'
  end

  protected
  include NoosferoTestHelper

end

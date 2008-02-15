class MembershipsController < MyProfileController

  def index
    @memberships = profile.memberships
  end

  def join
    @to_join = Profile.find(params[:id])
    if request.post? && params[:confirmation]
      @to_join.add_member(profile)
      redirect_to @to_join.url
    end
  end

  def new_community
    @community = Community.new(params[:community])
    if request.post?
      if @community.save
        @community.add_member(profile)
        redirect_to :action => 'index'
      end
    end
  end

end

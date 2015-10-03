class AdminController < AuthenticatedController
  before_action :require_admin

  def require_admin
    if !current_user.admin?
      flash[:danger] = 'You are not allowed to access this area'
      redirect_to home_path unless current_user.admin?
    end
  end
end

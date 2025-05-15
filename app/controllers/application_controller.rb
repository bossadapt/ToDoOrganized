class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :configure_permitted_parameters, if: :devise_controller?
  allow_browser versions: :modern
  protected
  # does nothing
  # def default_url_options
  #  { script_name: "/todoorganized" }
  # end
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name ])
  end
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end
end

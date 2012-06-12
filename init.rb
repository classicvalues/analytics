Canvas.reloadable_plugin(File.dirname(__FILE__))

controller_path = File.dirname(__FILE__)+'/app/controllers'
ActiveSupport::Dependencies.autoload_paths.delete controller_path
ActiveSupport::Dependencies.autoload_paths.unshift controller_path

Rails.configuration.to_prepare do
  view_path = File.dirname(__FILE__)+'/app/views'
  ::ApplicationController.view_paths.delete view_path
  ::ApplicationController.view_paths.unshift view_path

  Permissions.register :view_analytics,
    :label => lambda { I18n.t('#role_override.permissions.view_analytics', "View analytics pages") },
    :available_to => %w(TaEnrollment TeacherEnrollment AccountAdmin AccountMembership),
    :true_for => %w(AccountAdmin)

  require_dependency 'analytics/extensions'

  # This is in a separate file so the Delayed::Periodic job is only created
  # one time.
  require 'analytics/periodic_jobs'
end

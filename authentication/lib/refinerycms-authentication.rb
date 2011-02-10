require 'devise'
require 'refinerycms-core'

module Refinery
  module Authentication

    class Engine < Rails::Engine
      config.autoload_paths += %W( #{config.root}/lib )

      config.to_prepare do
        [::ApplicationController, ::Admin::BaseController].class_eval do |c|
          c.send :include, AuthenticatedSystem if defined?(c)
        end
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_users"
          plugin.version = %q{0.9.9}
          plugin.menu_match = /(refinery|admin)\/users$/
          plugin.activity = {
            :class => User,
            :title => 'login'
          }
          plugin.url = {:controller => "/admin/users"}
        end
      end
    end
  end

  class << self
    attr_accessor :authentication_login_field
    def authentication_login_field
      @authentication_login_field ||= 'login'
    end
  end
end
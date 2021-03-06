require 'blacklight'
require 'blacklight/gallery'
require 'blacklight_advanced_search'
require 'blacklight/maps'
require 'blacklight_range_limit'
require 'bpluser'
require 'typhoeus'
require 'devise'
require 'devise-guests'
require 'omniauth'
require 'omniauth-ldap'
require 'omniauth-facebook'
require 'omniauth-polaris'
require 'bootstrap-sass'
require 'font-awesome-sass'
require 'unicode'
require 'madison'
require 'iiif/presentation'

module CommonwealthVlrEngine

  class Engine < Rails::Engine

    # for db migrations
    engine_name 'commonwealth_vlr_engine'

    # This makes our rake tasks visible.
    rake_tasks do
      Dir.chdir(File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))) do
        Dir.glob(File.join('tasks', '*.rake')).each do |railtie|
          load railtie
        end
      end
      #load "#{config.root}/tasks/dc_public.rake"
    end

    # needs to be explicit as of sprockets-rails >=3.*
    initializer 'commonwealth.assets.precompile' do |app|
      app.config.assets.precompile += %w(commonwealth-vlr-engine/*.png commonwealth-vlr-engine/*.gif commonwealth-vlr-engine/openseadragon/*.png)
    end

  end
end

require 'erb'
require 'hashie'
require 'open-uri'
require 'rexml/document'
require 'sinatra/base'
require 'yaml'

module GreenScreen

  class MonitoredProject

    attr_reader :name, :last_build_status, :activity, :last_build_time, :web_url, :last_build_label

    def initialize(project)
      @activity = project.attributes["activity"]
      @last_build_time = Time.parse(project.attributes["lastBuildTime"]).localtime
      @web_url = project.attributes["webUrl"]
      @last_build_label = project.attributes["lastBuildLabel"]
      @last_build_status = project.attributes["lastBuildStatus"].downcase
      @name = project.attributes["name"]
    end

  end

  class App < Sinatra::Base

    set :app_file, __FILE__
    set :server, "thin"

    get '/' do

      @projects = []
      @auto_refresh_period = 15

      settings.config.sources.each do |source|
        begin
          xml = REXML::Document.new(open(source.url))
          projects = xml.elements["//Projects"]

          projects.each do |project|
            monitored_project = MonitoredProject.new(project)
            if source.jobs
              if source.jobs.detect {|job| job == monitored_project.name}
                @projects << monitored_project
              end
            else
              @projects << monitored_project
            end
          end
        rescue => e
          $stderr.puts "ERROR loading #{source.url}"
        end
      end

      erb :index

    end

  end
end

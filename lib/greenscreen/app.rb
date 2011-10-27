require 'erb'
require 'open-uri'
require 'rexml/document'
require 'sinatra/base'
require 'yaml'

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

module GreenScreen
  class App < Sinatra::Base

    set :app_file, __FILE__

    get '/' do
      servers = YAML.load_file 'config.yml'
      return "Add the details of build server to the config.yml file to get started" unless servers

      @projects = []
      @auto_refresh_period = 15

      servers.each do |server|
        cc_xml_url = server["url"]
        begin
          xml = REXML::Document.new(open(cc_xml_url))
          projects = xml.elements["//Projects"]

          projects.each do |project|
            monitored_project = MonitoredProject.new(project)
            if server["jobs"]
              if server["jobs"].detect {|job| job == monitored_project.name}
                @projects << monitored_project
              end
            else
              @projects << monitored_project
            end
          end
        rescue => e
          $stderr.puts "ERROR loading #{cc_xml_url}"
        end
      end

      erb :index

    end

    get '/test' do
      xml = REXML::Document.new(open(File.expand_path("../test-cc.xml", __FILE__)))
      @projects = xml.elements["//Projects"].map do |project_element|
        MonitoredProject.new(project_element)
      end
      erb :index
    end

  end
end

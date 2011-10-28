require 'erb'
require 'hashie'
require 'open-uri'
require 'rexml/document'
require 'sinatra/base'
require 'yaml'

module GreenScreen

  Job = Struct.new(:name, :url, :activity, :last_run)
  Run = Struct.new(:label, :time, :status)

  class App < Sinatra::Base

    set :app_file, __FILE__
    set :server, "thin"

    get '/' do

      @auto_refresh_period = 15

      @jobs = settings.config.sources.map do |source|
        load_source(source)
      end.flatten

      erb :index

    end

    private

    def load_source(source)
      jobs = load_cc_xml(source.url)
      if included_jobs = source.jobs
        jobs = jobs.select { |j| included_jobs.member?(j.name) }
      end
      jobs
    rescue => e
      $stderr.puts "ERROR loading #{source.url.inspect}: #{e}"
    end

    def load_cc_xml(url)
      xml = REXML::Document.new(open(url))
      xml.elements["//Projects"].map do |project_element|
        data = project_element.attributes
        Job.new.tap do |job|
          job.name = data["name"]
          job.url = data["webUrl"]
          job.activity = data["activity"]
          job.last_run = Run.new.tap do |run|
            run.label = data["lastBuildLabel"]
            run.time = Time.parse(data["lastBuildTime"]).localtime
            run.status = data["lastBuildStatus"]
          end
        end
      end
    end

  end
end

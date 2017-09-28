require 'jenkins_api_client'
require 'pry'

module JenkinsApi
  class ProjetJenkins
    def initialize
      @client = JenkinsApi::Client.new(:server_ip => 'jenkins.andersenlab.com',
                                       :server_port => '80',
                                       :username => 'v.shevchenko',
                                       :password => '0ed19e3c034d74e37a167263f8802b70')

    end

    def jenkins_build_job (way_project)
      if check_status(way_project) != "running" #|| "failure" || "unstable" || "not_run"
        p @client.job.build(way_project)
      else
        p "Project is running"
      end
    end

    def jenkins_stop_build_job (way_project)
      if check_status(way_project) == "running"
        @client.job.stop_build(good_projct)
      else
        p "Project is not running"
      end
    end


    def jenkins_status_project (way_project)
      status_project = check_status(way_project)
      if status_project == "running"
        p 'Jean: %projectname% is building now.'
        elsif status_project == "success"
        p "Jean: %projectname% was built at #{time(way_project)} with status #{status_project}."
        else
      end
    end

    def monitoring

    end

    private

    def check_status(way)
      @client.job.get_current_build_status(way)
    end

    def time(way_project)
      build_number = @client.job.get_current_build_number(way_project)
      time = @client.job.get_build_details(way_project, build_number)["timestamp"]
      Time.at(time/1000).strftime("%b %d, %Y %l:%M:%S %p")
    end


  end
end


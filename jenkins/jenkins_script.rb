require 'jenkins_api_client'
require 'pry'

module JenkinsApi
  class Builder
    def initialize
      @client = JenkinsApi::Client.new(:server_ip => 'jenkins.andersenlab.com',
                                       :server_port => '80',
                                       :username => 'v.shevchenko',
                                       :password => '0ed19e3c034d74e37a167263f8802b70')
    end

    def build_job_jenkins(way_project)
      @client.job.build(way_project)
    end

  end

  class Status

  end

  class Monitoring

  end

end

# JenkinsApi::Builder.new.some_def(some)
# JenkinsApi::Builder.some_def(some)


name = "DevopsTest/job/GradleUnitTest"
JenkinsApi::Builder.new.build_job_jenkins(name)


# puts @client.job.list("DevopsTest")
# puts @client.job.list_all
# puts @client.job





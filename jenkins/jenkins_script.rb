require 'jenkins_api_client'
require 'pry'

module JenkinsApi
  class ProjectJenkins
    def initialize
      @client = JenkinsApi::Client.new(:server_ip => 'jenkins.andersenlab.com',
                                       :server_port => '80',
                                       :username => 'v.shevchenko',
                                       :password => '0ed19e3c034d74e37a167263f8802b70')

    end

    def jenkins_status_project (way_project, project_name)
      status_project = @client.job.get_current_build_status(way_project)
      if status_project == "running"
        return "Jean: #{project_name} is building now."
      else
        return "Jean: #{project_name} was built at #{time(way_project)} with status #{status_project}."
      end
    end

    def jenkins_build_job (way_project, project_name)
      status_project = @client.job.get_current_build_status(way_project)
      if status_project != "running"
        @client.job.build(way_project)
        "Jean: Ok, build #{project_name} has started."
      else status_project == "running"
        "Jean: Sorry, #{project_name} is already in progress, please wait for result."
      end
    end

    def jenkins_stop_build_job (way_project)
      status_project = @client.job.get_current_build_status(way_project)
      if  status_project == "running"
        @client.job.stop_build(way_project)
      else
        p "Project is not running"
      end
    end

    def monitoring_status(way_project)
      status = @client.job.get_current_build_status(way_project)
      if status != "running"
        'Jean:  I can`t reach %адрес сайта%, but it`s not building, maybe i need to rebuild it? '
      else
        'Jean: ProjectName is building now.'
      end
    end

    private

    # def check_status(way)
    #
    # end

    def time(way_project)
      build_number = @client.job.get_current_build_number(way_project)
      time = @client.job.get_build_details(way_project, build_number)["timestamp"]
      Time.at(time/1000).strftime("%b %d, %Y %l:%M:%S %p")
    end


  end
end

# way_project = "DevopsTest/job/GradleUnitTest"
# way_project2 = "DevopsTest/job/online-shopJSFinal"
#
# project_name = "asfscd"

#Time
# JenkinsApi::ProjectJenkins.new.send :time, good_project
# JenkinsApi::ProjectJenkins.new.time(bad_project)

############ STATUS ###################################################################################
# p JenkinsApi::ProjectJenkins.new.jenkins_status_project(way_project2, project_name)

############# BULDER ###################################################################################
# JenkinsApi::ProjectJenkins.new.jenkins_build_job(bad_project)

############ MONITORING ##########################################################################################
# JenkinsApi::ProjectJenkins.new.monitoring_status(bad_project)


# p JenkinsApi::ProjectJenkins.new.jenkins_build_job(bad_project)
# p JenkinsApi::ProjectJenkins.new.jenkins_status_project(bad_project)
# # p JenkinsApi::ProjectJenkins.new.jenkins_stop_build_job(bad_project)
# p JenkinsApi::ProjectJenkins.new.monitoring_status(bad_project)
#####################################################################

# @client = JenkinsApi::Client.new(:server_ip => 'jenkins.andersenlab.com',
#                                  :server_port => '80',
#                                  :username => 'v.shevchenko',
#                                  :password => '0ed19e3c034d74e37a167263f8802b70')

# p @client.job.get_current_build_status(bad_project )

# p current_build_number = @client.job.get_current_build_number("DevopsTest/job/GradleUnitTest")
# p details = @client.job.get_build_details("DevopsTest/job/GradleUnitTest", current_build_number)

# p @client.api_get_request("http://jenkins.andersenlab.com/job/DevopsTest/job/GradleUnitTest/152/")

# список билдов
# p @client.job.get_builds('DevopsTest/job/GradleUnitTest')

# time
# build_numbe = @client.job.get_current_build_number(good_project)
# p time = @client.job.get_build_details(good_project, build_numbe)["timestamp"] #["result"]
# p Time.at(time/1000) #.strftime("%m/%d/%Y")
# p Time.at(time/1000).strftime("%b %d, %Y %l:%M:%S %p")
########################################################################

# p aa = @client.job.get_console_output(good_projct)
# aa["output"]


# p @client.job.list_details(good_projct)

# @client.job.build(good_projct)


# p jobs = @client.job.get_current_build_status(good_projct)
# p @client.job.get_current_build_number(good_projct)


#  Доступин сайт или нет!!!!!
# p @client.job.poll(good_projct)

# Включить сайт
# p @client.job.enable(good_projct)


# Access denied. Please ensure that Jenkins is set up to allow access to this operation.
# p @client.job.get_build_details(good_projct)
# p @client.job.get_build_params(good_projct)




# code = @client.job.build(initial_jobs[0])
# raise "Could not build the job specified" unless code == '201'







# # puts @client.job.list("DevopsTest")
# # puts @client.job.list_all
# # puts @client.job

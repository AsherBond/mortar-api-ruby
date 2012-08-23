require 'set'

module Mortar
  class API
    module Jobs

      STATUS_VALIDATING_SCRIPT = "validating_script"
      STATUS_SCRIPT_ERROR      = "script_error"
      STATUS_PLAN_ERROR        = "plan_error"
      STATUS_STARTING_CLUSTER  = "starting_cluster"
      STATUS_RUNNING           = "running"
      STATUS_SUCCESS           = "success"
      STATUS_EXECUTION_ERROR   = "execution_error"
      STATUS_SERVICE_ERROR     = "service_error"
      STATUS_STOPPING          = "stopping"
      STATUS_STOPPED           = "stopped"

      STATUSES_IN_PROGRESS    = Set.new([STATUS_VALIDATING_SCRIPT, 
                                         STATUS_STARTING_CLUSTER, 
                                         STATUS_RUNNING, 
                                         STATUS_STOPPING])

      STATUSES_COMPLETE       = Set.new([STATUS_SCRIPT_ERROR, 
                                        STATUS_PLAN_ERROR,
                                        STATUS_SUCCESS,
                                        STATUS_EXECUTION_ERROR,
                                        STATUS_SERVICE_ERROR,
                                        STATUS_STOPPED])
    end
    
    
    # POST /vX/jobs
    def post_job_existing_cluster(project_name, pigscript, git_ref, cluster_id, options={})
      parameters = options[:parameters] || {}
      request(
        :expects  => 200,
        :method   => :post,
        :path     => versioned_path("/jobs"),
        :body     => json_encode({"project_name" => project_name,
                                  "pigscript_name" => pigscript,
                                  "git_ref" => git_ref,
                                  "cluster_id" => cluster_id,
                                  "parameters" => parameters
                                  }))
    end
    
    # POST /vX/jobs
    def post_job_new_cluster(project_name, pigscript, git_ref, cluster_size, options={})
      keep_alive = options[:keepalive].nil? ? false : options[:keepalive]
      parameters = options[:parameters] || {}
      request(
        :expects  => 200,
        :method   => :post,
        :path     => versioned_path("/jobs"),
        :body     => json_encode({"project_name" => project_name,
                                  "pigscript_name" => pigscript,
                                  "git_ref" => git_ref,
                                  "cluster_size" => cluster_size,
                                  "keep_alive" => keep_alive,
                                  "parameters" => parameters
                                  }))
    end
    
    # GET /vX/jobs
    def get_jobs
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/jobs")
      )
    end
    
    # GET /vX/jobs/:job_id
    def get_job(job_id)
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/jobs/#{job_id}")
      )
    end
  end
end
#
# Copyright 2012 Mortar Data Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'set'

module Mortar
  class API
    module Illustrate

      STATUS_QUEUED           = "QUEUED"
      STATUS_GATEWAY_STARTING = "GATEWAY_STARTING"
      STATUS_PROGRESS         = "PROGRESS"
      STATUS_BUILDING_PLAN    = "BUILDING_PLAN"
      STATUS_READING_DATA     = "READING_DATA"
      STATUS_PRUNING_DATA     = "PRUNING_DATA"

      STATUS_FAILURE          = "FAILURE"
      STATUS_SUCCESS          = "SUCCESS"
      STATUS_KILLED           = "KILLED"

      STATUSES_IN_PROGRESS    = Set.new([STATUS_QUEUED, 
                                         STATUS_GATEWAY_STARTING,
                                         STATUS_PROGRESS, 
                                         STATUS_BUILDING_PLAN, 
                                         STATUS_READING_DATA, 
                                         STATUS_PRUNING_DATA])

      STATUSES_COMPLETE       = Set.new([STATUS_FAILURE, 
                                        STATUS_SUCCESS,
                                        STATUS_KILLED])
    end
    
    # GET /vX/illustrates/:illustrate
    def get_illustrate(illustrate_id, options = {})
      exclude_result = options[:exclude_result] || false
      request(
        :expects  => 200,
        :idempotent => true,
        :method   => :get,
        :path     => versioned_path("/illustrates/#{illustrate_id}"),
        :query    => {:exclude_result => exclude_result}
      )
    end
    
    # POST /vX/illustrates
    def post_illustrate(project_name, pigscript, pigscript_alias, skip_pruning, git_ref, options = {})
      parameters = options[:parameters] || {}
      body = {"project_name" => project_name,
              "pigscript_name" => pigscript,
              "alias" => pigscript_alias,
              "skip_pruning" => skip_pruning,
              "git_ref" => git_ref,
              "parameters" => parameters
              }

      #If no pig_version is set, leave it to server to figure out version.
      unless options[:pig_version].nil?
        body["pig_version"] = options[:pig_version]
      end

      unless options[:project_script_path].nil?
        body["project_script_path"] = options[:project_script_path]
      end

      request(
        :expects  => 200,
        :method   => :post,
        :path     => versioned_path("/illustrates"),
        :body     => json_encode(body)
      )
    end    
  end
end

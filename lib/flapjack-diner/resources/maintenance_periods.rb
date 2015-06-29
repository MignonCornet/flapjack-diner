require 'httparty'
require 'json'
require 'uri'

require 'flapjack-diner/version'
require 'flapjack-diner/argument_validator'

module Flapjack
  module Diner
    module Resources
      module MaintenancePeriods

        def create_scheduled_maintenances(*args)
          data = unwrap_data(*args)
          validate_params(data) do
            validate :query => :id, :as => :uuid
            validate :query => :start_time, :as => [:required, :time]
            validate :query => :end_time,   :as => [:required, :time]
            validate :query => :summary,    :as => :string
            validate :query => :check, :as => :singular_link_uuid
            validate :query => :tag, :as => :singular_link_uuid
          end
          # FIXME validate that check or tag is being passed
          perform_post(:scheduled_maintenances, '/scheduled_maintenances', data)
        end

        def update_scheduled_maintenances(*args)
          data = unwrap_data(*args)
          validate_params(data) do
            validate :query => :check, :as => :singular_link_uuid
          end
          perform_patch(:scheduled_maintenances, '/scheduled_maintenances',
                        data)
        end

        def update_unscheduled_maintenances(*args)
          data = unwrap_data(*args)
          validate_params(data) do
            validate :query => :end_time, :as => :time
            validate :query => :check, :as => :singular_link_uuid
          end
          perform_patch(:unscheduled_maintenances, '/unscheduled_maintenances',
                        data)
        end

        def delete_scheduled_maintenances(*ids)
          if ids.nil? || ids.empty?
            raise "'delete_scheduled_maintenances' requires " \
                  "at least one scheduled maintenance id parameter"
          end
          perform_delete(:scheduled_maintenances, '/scheduled_maintenances',
            *ids)
        end
      end
    end
  end
end

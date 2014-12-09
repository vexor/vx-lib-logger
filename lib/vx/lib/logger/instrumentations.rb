require 'active_support'

module Vx ; module Lib ; module Logger
  class Instrumentations

    class << self

      def activate
        ActiveSupport::Notifications.subscribe(/.*/) do |event, started, finished, _, payload|
          case event
          when /\.action_controller$/
            process_action_controller(event, started, finished, payload)
          end
        end
      end

      private

        def process_action_controller(event, started, finished, payload)
        end

    end

  end
end ; end ; end

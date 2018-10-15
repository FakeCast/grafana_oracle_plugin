module Api
  module V1
    class DatasourceController < ApplicationController
      before_action :set_table_name

      def base
        render status: 200, json: ""
      end

      def search
        render json: Metric.metric_list.to_json
      end

      def query
        metric_functions = {
          :array_pool_status => lambda { | tier, location | Metric.array_pool_status(Snelnx998db.all, tier, location) }
        }
        selected = params[:targets][0][:target]
        metric = Metric.parse_metric(selected)
        render json: metric_functions[metric[:metric].to_sym].call(metric[:field2], metric[:field1]).to_json
      end

      def annotations
      end


      private
      # Set the view name
      def set_table_name
        Snelnx998db.table_name = 'V_GRAFANA_POOLS'
      end
    end
  end
end

module Api
  module V1
    class DatasourceController < ApplicationController
      def base
        render status: 200, json: ""
      end

      def search
        render json: ["Pool -Isilon SX410 0117 ","2","3","10"].to_json
      end

      def query
        series = params[:targets][0][:target]
        render json: pool.to_json
      end

      def annotations

      end

      def pool(serial="SX410-251533-0117", dspool="x410_120tb_2.3tb-ssd_32gb")
        U28db.table_name = "isi_pools"
        result =  U28db.where(:cdserial => serial, :dspool => dspool).as_json
    #    result.each do | x |
    #      x["dtdata"] = x["dtdata"].to_time.to_i * 1000
    #  end
      datapoints = []
      result.each do | x |
        datapoints << [x["nmused"], (x["dtdata"].to_time.to_i * 1000)]
      end
       output = [
         {
           target: "Used",
           datapoints: datapoints

         }
       ]

        print output.to_json

        return output
      end
    end
  end
end

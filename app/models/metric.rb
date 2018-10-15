class Metric

  # Parse selected metric
  def self.parse_metric(metric)
    parsed_metrics = {
      :metric => metric.split("|")[0].strip,
      :field1 => metric.split("|")[1].strip,
      :field2 => metric.split("|")[2].strip
    }
    return parsed_metrics
  end

  # List of available metrics
  def self.metric_list
    metrics = [
      "array_pool_status | Santo André | class1",
      "array_pool_status | Santo André | class2",
      "array_pool_status | Santo André | class3",
      "array_pool_status | Rio de Janeiro | class1",
      "array_pool_status | Rio de Janeiro | class2",
      "array_pool_status | Rio de Janeiro | class3"
    ]
    return metrics
  end


  def self.array_pool_status(elements, tier, location)
    array_definition = {
      :class1 => {
        :"000597000013" => {:vendor => "EMC", :location => "Santo André"},
        :"BR500153700001" => {:vendor => "EMC", :location => "Santo André"},
        :"BR500161700001" => {:vendor => "EMC", :location => "Santo André"},
        :"000297000439" => {:vendor => "EMC", :location => "Santo André"},
        :"000597800068" => {:vendor => "EMC", :location => "Santo André"},
        :"000597000004" => {:vendor => "EMC", :location => "Santo André"}
      },
      :class2 => {
        :"000595700007" => {:vendor => "EMC", :location => "Santo André"},
        :"000592600076" => {:vendor => "EMC", :location => "Santo André"},
        :"2MK6510084" => {:vendor => "HP", :location => "Santo André"},
        :"1305963" => {:vendor => "HP", :location => "Santo André"},
        :"240687" => {:vendor => "HITACHI", :location => "Santo André"},
        :"000595700008" => {:vendor => "EMC", :location => "Santo André"},
        :"000292600010" => {:vendor => "EMC", :location => "Santo André"},
        :"2MK6040311" => {:vendor => "HP", :location => "Santo André"},
        :"2MK6510085" => {:vendor => "HP", :location => "Santo André"},
        :"MXN706363V" => {:vendor => "HP", :location => "Santo André"},
        :"000592600075" => {:vendor => "EMC", :location => "Rio de Janeiro"},
        :"5600_0004" => {:vendor => "HUAWEI", :location => "Rio de Janeiro"},
        :"6800_0002" => {:vendor => "HUAWEI", :location => "Rio de Janeiro"},
        :"000290103042" => {:vendor => "EMC", :location => "Rio de Janeiro"},
        :"000292600147" => {:vendor => "EMC", :location => "Rio de Janeiro"},
        :"000595700042" => {:vendor => "EMC", :location => "Rio de Janeiro"},
        #:"2MK7030162" => {:vendor => "HP", :location => "Rio de Janeiro"},
        :"5500_0003" => {:vendor => "HUAWEI", :location => "Rio de Janeiro"},
        :"CKM00152002164" => {:vendor => "EMC", :location => "Rio de Janeiro"},
        :"CKM00150400816" => {:vendor => "EMC", :location => "Rio de Janeiro"},
        :"CKM00150400815" => {:vendor => "EMC", :location => "Rio de Janeiro"},
        :"CKM00164901958" => {:vendor => "EMC", :location => "Rio de Janeiro"},
      },
      :class3 => {
        :"CKM00124902213" => {:vendor => "EMC", :location => "Santo André"},
        :"CKM00112600549" => {:vendor => "EMC", :location => "Santo André"},
        :"CKM00134401144" => {:vendor => "EMC", :location => "Santo André"},
        :"SX-251533-0117" => {:vendor => "EMC", :location => "Santo André"},
        :"CKM00154803864" => {:vendor => "EMC", :location => "Santo André"},
        :"CKM00151901571" => {:vendor => "EMC", :location => "Santo André"},
        :"CK200150400009" => {:vendor => "EMC", :location => "Santo André"},
        :"CK200150500173" => {:vendor => "EMC", :location => "Santo André"},
        :"CK200073700795" => {:vendor => "EMC", :location => "Santo André"},
        :"CKM00160200776" => {:vendor => "EMC", :location => "Santo André"}
      }
    }
    datapoints = []
    array_definition[tier.to_sym].select { | storage, data | data[:location] == location }.each do | array, details |
      array_data = elements.select {|x| x[:cdframe_id] == array.to_s }
      total = array_data.sum {|h| h[:total]} / 1024
      alocado = array_data.sum {|h| h[:alocado]} / 1024
      escrito = array_data.sum {|h| h[:escrito]} / 1024
      livre = array_data.sum {|h| h[:disp_escrita]} / 1024
      datapoints << [
        array_data.first[:cdframe_id],
        details[:vendor],
        array_data.first[:frame],
        array_data.first[:tipo_disco],
        total,
        alocado,
        escrito,
        livre,
        ((escrito / total) * 100).round,
        ((alocado / total) * 100).round
      ]
    end
    data = [{
      :type => "table",
      :columns => [
        {:text => "Frame ID", :type => "string" },
        {:text => "Vendor", :type => "string" },
        {:text => "Frame Name", :type => "string" },
        {:text => "Provisioning", :type => "string" },
        {:text => "Total", :type => "number" },
        {:text => "Alocado", :type => "number" },
        {:text => "Escrito", :type => "number" },
        {:text => "Livre", :type => "number" },
        {:text => "% Livre", :type => "number" },
        {:text => "% Alocado", :type => "number" },
      ],
      :rows => datapoints
    }]

    return data
  end

end

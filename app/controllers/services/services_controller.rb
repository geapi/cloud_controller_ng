module VCAP::CloudController
  rest_controller :Services do
    define_attributes do
      attribute :label,             String
      attribute :description,       String
      attribute :info_url,          Message::URL, :default => nil
      attribute :documentation_url, Message::URL, :default => nil
      attribute :acls,              {"users" => [String], "wildcards" => [String]}, :default => nil
      attribute :timeout,           Integer, :default => nil
      attribute :active,            Message::Boolean, :default => false
      attribute :bindable,          Message::Boolean, :default => true
      attribute :extra,             String, :default => nil
      attribute :unique_id,         String, :default => nil, :exclude_in => [:update]
      attribute :tags,              [String], :default => []

      # NOTE: DEPRECATED
      #
      # These attributes are required for V1 service providers only. The
      # constraints have been relaxed on the model and the table to allow
      # V2 service providers to register services without them.
      #
      # Since this controller is the only way for a V1 provider to register
      # services, these requirements are needed until support for V1
      # providers is officially dropped.
      attribute :provider,          String
      attribute :version,           String
      attribute :url,               Message::URL

      to_many   :service_plans
    end

    query_parameters :active

    def self.translate_validation_exception(e, attributes)
      label_provider_errors = e.errors.on([:label, :provider])
      if label_provider_errors && label_provider_errors.include?(:unique)
        Errors::ServiceLabelTaken.new("#{attributes["label"]}-#{attributes["provider"]}")
      else
        Errors::ServiceInvalid.new(e.errors.full_messages)
      end
    end
  end
end

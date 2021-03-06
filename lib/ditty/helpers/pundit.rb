# frozen_string_literal: true

require 'pundit'

module Ditty
  module Helpers
    module Pundit
      include ::Pundit

      def authorize(record, query)
        query = :"#{query}?" unless query[-1] == '?'
        super
      end

      def permitted_attributes(record, action)
        param_key = PolicyFinder.new(record).param_key
        policy = policy(record)
        method_name = if policy.respond_to?("permitted_attributes_for_#{action}")
                        "permitted_attributes_for_#{action}"
                      else
                        'permitted_attributes'
                      end

        policy_fields = policy.public_send(method_name)
        request.params.fetch(param_key, {}).select do |key, _value|
          policy_fields.include? key.to_sym
        end
      end

      def pundit_user
        current_user
      end
    end
  end
end

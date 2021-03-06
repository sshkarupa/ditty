# frozen_string_literal: true

require 'ditty/policies/application_policy'

module Ditty
  class RolePolicy < ApplicationPolicy
    def create?
      user&.super_admin?
    end

    def list?
      create?
    end

    def read?
      create?
    end

    def update?
      read?
    end

    def delete?
      create?
    end

    def permitted_attributes
      [:name]
    end

    class Scope < ApplicationPolicy::Scope
      def resolve
        if user&.super_admin?
          scope
        else
          scope.where(id: -1)
        end
      end
    end
  end
end

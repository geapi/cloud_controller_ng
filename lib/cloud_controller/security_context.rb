# Copyright (c) 2009-2012 VMware, Inc.

module VCAP::CloudController
  module SecurityContext
    def self.clear
      Thread.current[:vcap_user] = nil
      Thread.current[:vcap_token] = nil
    end

    def self.set(user, token = nil)
      Thread.current[:vcap_user] = user
      Thread.current[:vcap_token] = token
    end

    def self.current_user
      Thread.current[:vcap_user]
    end

    def self.admin?
      roles.admin?
    end

    def self.roles
      VCAP::CloudController::Roles.new(token)
    end

    def self.token
      Thread.current[:vcap_token]
    end

    def self.current_user_email
      token['email'] if token
    end

    def self.current_user_has_email?(email)
      current_user_email && current_user_email.downcase == email.downcase
    end
  end
end

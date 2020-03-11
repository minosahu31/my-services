module MyServices
  module Actions
    module Post
      module ClassMethods
        def sign_in(email, password, request)
          user = User.where(email: email).last
      
          unless user.present?
            user = User.where(alternate_email: email).last
          end
      
          if user.present? and user.valid_password?(password) and user.role != User::TENANT #and user.role != User::SITE
              refresh_token = Digest::MD5.hexdigest(Time.now.to_s + user.email)
              user.update current_sign_in_at: Time.zone.now
              user.update sign_in_count: (user.sign_in_count + 1)
              Audit.create(user_id: user.id, action: "login", action_occured_time: Time.zone.now)
              # Rails.logger.request.info(request.headers)
              login_response(user, refresh_token, request)
          else
            # Rails.logger.request.info(request.headers)
            # Rails.logger.auth_failure.info("#{params.inspect}")
            { success: false, message: "Invalid Email or Password"}
          end
        end
        def login_response(user, refresh_token, request)
          client_id = request.headers["REMOTE_ADDR"]
          $redis.hmset(refresh_token, "user_id", user.id,  "client_id", client_id)
          $redis.expire refresh_token, 43200
          payload = authentication_payload(user, refresh_token)
          $redis.sadd(user.email, refresh_token)
          authentication_token = payload[:authentication_token].split(".").last
          $redis.hset(authentication_token, "client_id", client_id)
          payload 
        end
        def authentication_payload(user, refresh_token)
          return nil unless user && user.id
          if user.role == User::TENANT
            tenant = Tenant.where(user_id: user.id, status: true).first
            tenant_id = tenant.id
            name = tenant.first_name + " " + tenant.last_name
            multiple_tenant_accounts = user.tenants.where(status: true).count > 1 ? true : false
          elsif user.role == User::SITE
            name = "Site Admin"
          else
            name = "Admin"
          end 
          site_id = user.site_id if user.site_id.present?
          {
            authentication_token: ::AuthToken.encode({ user_id: user.id }),
            user: { id: user.id, email: user.email, role: user.role, name: name, site_id: site_id,
                    sign_in_count: user.sign_in_count, tenant_id: tenant_id, multiple_tenant_accounts: multiple_tenant_accounts} ,
            refresh_token: refresh_token,
            site_id: user.site_id,
            success: true
          }
        end
        def sign_out(request)
          refresh_token = request.headers["HTTP_REFRESH_TOKEN"]
          auth_token = request.headers["HTTP_AUTHENTICATION_TOKEN"]
          if refresh_token.present?
            token_hash = $redis.hgetall(refresh_token)
            user = User.find(token_hash["user_id"].to_i)
            $redis.del(refresh_token)
            $redis.del(auth_token.split('.').last)
            $redis.srem(user.email, refresh_token)
            {:success=>true, :message => "Log out successful"}
          else
            {:success => false, :message => "Refresh token got nil"}
          end
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end


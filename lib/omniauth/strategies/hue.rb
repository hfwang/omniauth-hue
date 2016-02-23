require 'omniauth-oauth2'
require 'json'
require 'net/http'

module OmniAuth
  module Strategies
    class Hue < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://api.meethue.com',
        :authorize_url => '/oauth2/auth',
        :token_url => '/oauth2/token'
      }
      option :authorize_options, [:app_id, :device_name, :device_id]
      option :scope, :app
      option :app_id
      option :device_name
      option :device_id

      uid {
        raw_info[0]["id"]
      }

      extra {
        { :bridges => raw_info }
      }

      info do
        {
          :name => raw_info[0]["name"]
        }
      end

      def authorize_params
        params = super

        # Setting clientid (as opposed to the more normal client_id) is
        # specified by the documentation, but not required... but we set both
        # just in case
        params[:clientid] = options.client_id

        params[:appid] = params.delete(:app_id)
        params[:devicename] = params.delete(:device_name)
        params[:deviceid] = params.delete(:device_id)
        params
      end

      def raw_info
        @raw_info ||= access_token.get("/v1/bridges").parsed
      end

      protected
      def build_access_token
        code = request.params["code"]
        get_token(code)
      end

      # We can't use the normal OAuth2 token fetching machinery because Hue is... weird.
      def get_token(code, access_token_class = ::OAuth2::AccessToken)
        opts = {:raise_errors => client.options[:raise_errors], :parse => true}
        query_params = {
          code: code,
          grant_type: "authorization_code"
        }
        headers = {
          "Authorization" => "Basic " + Base64.strict_encode64("#{options.client_id}:#{options.client_secret}")
        }
        opts = {
          :body => "",
          :headers => headers,
          :params => query_params
        }
        response = client.request(:post, client.token_url, opts)
        error = ::OAuth2::Error.new(response)
        raise(error) if client.options[:raise_errors] && !(response.parsed.is_a?(Hash) && response.parsed['access_token'])

        parsed_response = response.parsed
        parsed_response["expires_in"] = parsed_response["access_token_expires_in"]
        token = access_token_class.from_hash(client, parsed_response)
        return token
      end
    end
  end
end

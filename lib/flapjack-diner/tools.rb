require 'uri'

module Flapjack
  module Diner
    module Tools

      private

      def extract_get(name, response)
        result = if response.nil? || response.is_a?(TrueClass) || !response.is_a?(Hash)
          response
        else
          response[name]
        end

        return_keys_as_strings.is_a?(TrueClass) ? result : symbolize(result)
      end

      def perform_get(path, ids = [], data = [])
        req_uri = build_uri(path, ids, data)
        logger.info "GET #{req_uri}" if logger
        response = get(req_uri.request_uri)
        handle_response(response)
      end

      def perform_post(path, ids = [], data = [])
        req_uri = build_uri(path, ids)
        if logger
          log_post = "POST #{req_uri}"
          log_post << "\n  Params: #{data.inspect}" if data
          logger.info log_post
        end
        opts = data ? {:body => prepare_nested_query(data).to_json, :headers => {'Content-Type' => 'application/vnd.api+json'}} : {}
        response = post(req_uri.request_uri, opts)
        handle_response(response)
      end

      def perform_patch(path, ids = [], data = [])
        req_uri = build_uri(path, ids)
        if logger
          log_patch = "PATCH #{req_uri}"
          log_patch << "\n  Params: #{data.inspect}" if data
          logger.info log_patch
        end
        opts = data ? {:body    => prepare_nested_query(data).to_json,
                       :headers => {'Content-Type' => 'application/json-patch+json'}} : {}
        response = patch(req_uri.request_uri, opts)
        handle_response(response)
      end

      def perform_delete(path, ids = [], data = [])
        req_uri = build_uri(path, ids, data)
        logger.info "DELETE #{req_uri}" if logger
        response = delete(req_uri.request_uri)
        handle_response(response)
      end

      def handle_response(response)
        response_body = response.body
        response_start = response_body ? response_body[0..300] : nil
        if logger
          response_message = " #{response.message}" unless (response.message.nil? || response.message == "")
          logger.info "  Response Code: #{response.code}#{response_message}"
          logger.info "  Response Body: #{response_start}" if response_start
        end
        parsed_response = response.respond_to?(:parsed_response) ? response.parsed_response : nil
        unless SUCCESS_STATUS_CODES.include?(response.code)
          self.last_error = {'status_code' => response.code}.merge(parsed_response)
          return nil
        end
        return true unless (response.code == 200) && parsed_response
        parsed_response
      end

      def validate_params(query = {}, &validation)
        ArgumentValidator.new(query).instance_eval(&validation) if block_given?
      end

      # copied from Rack::Utils -- builds the query string for GETs
      def build_nested_query(value, prefix = nil)
        if value.respond_to?(:iso8601)
          raise ArgumentError, "value must be a Hash" if prefix.nil?
          "#{prefix}=#{escape(value.iso8601)}"
        else
          case value
          when Array
            value.map { |v|
              build_nested_query(v, "#{prefix}[]")
            }.join("&")
          when Hash
            value.map { |k, v|
              build_nested_query(v, prefix ? "#{prefix}[#{escape(k)}]" : escape(k))
            }.join("&")
          when String, Integer
            raise ArgumentError, "value must be a Hash" if prefix.nil?
            "#{prefix}=#{escape(value.to_s)}"
          else
            prefix
          end
        end
      end

      def escaped_ids(ids = [])
        ids.collect{|id| URI.escape(id.to_s)}.join(',')
      end

      def escape(s)
        URI.encode_www_form_component(s)
      end

      def unwrap_ids_and_params(*args)
        ids    = []
        params = {}
        data   = []

        args.each do |arg|
          case arg
          when Array
            raise "Array arguments may only contain data Hashes" unless arg.all? {|a| a.is_a?(Hash)}
            data += arg
          when Hash
            params.update(arg)
          when String, Integer
            ids << arg.to_s
          else
            raise "Arguments must be a Hash (parameters), String/Integer (ids), or Arrays of Hashes (data)"
          end
        end

        [ids, params, data]
      end

      # used for the JSON data hashes in POST, PUT, DELETE
      def prepare_nested_query(value)
        if value.respond_to?(:iso8601)
          value.iso8601
        else
          case value
          when Array
            value.map { |v| prepare_nested_query(v) }
          when Hash
            value.inject({}) do |memo, (k, v)|
              memo[k] = prepare_nested_query(v)
              memo
            end
          when Integer, TrueClass, FalseClass, NilClass
            value
          else
            value.to_s
          end
        end
      end

      def protocol_host_port
        self.base_uri =~ /^(?:(https?):\/\/)?([a-zA-Z0-9][a-zA-Z0-9\.\-]*[a-zA-Z0-9])(?::(\d+))?/i
        protocol = ($1 || 'http').downcase
        host = $2
        port = $3

        port = if port.nil? || port.to_i < 1 || port.to_i > 65535
          'https'.eql?(protocol) ? 443 : 80
        else
          port.to_i
        end

        [protocol, host, port]
      end

      def build_uri(path, ids = [], params = [])
        pr, ho, po = protocol_host_port
        if !ids.nil? && !ids.empty?
          path += '/' + escaped_ids(ids)
        end
        URI::HTTP.build(:protocol => pr, :host => ho, :port => po,
          :path => path, :query => (params.nil? || params.empty? ? nil : build_nested_query(params)))
      end

      def last_error=(error)
        @last_error = error
      end

      def symbolize(obj)
        return obj.inject({}){|memo,(k,v)| memo[k.to_sym] =  symbolize(v); memo} if obj.is_a?(Hash)
        return obj.inject([]){|memo,v    | memo           << symbolize(v); memo} if obj.is_a?(Array)
        obj
      end

    end
  end
end

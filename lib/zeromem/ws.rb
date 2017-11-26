require "zeromem/ws/version"
require 'rjr/core_ext'
require 'rjr/nodes/ws'

module Zeromem
  module Ws
    class WsHeavy < RJR::Nodes::WS
      # WS initializer
      # @param [Hash] args the options to create the web socket node with
      # @option args [String] :host the hostname/ip which to listen on
      # @option args [Integer] :port the port which to listen on
      def initialize(args = {})
        super(args)
      end

      # Instructs node to send rpc request, and wait for / return response
      #
      # Implementation of Zeromem::Ws::WsHeavy#invoke
      # This is custom implementation of RJR::Node#invoke
      # to make things work perfectly under heavy load (thousands of ws queries per min)
      #
      # Do not invoke directly from em event loop or callback as will block the message
      # subscription used to receive responses
      #
      # @param [String] uri location of node to send request to, should be
      #   in format of ws://hostname:port
      # @param [String] rpc_method json-rpc method to invoke on destination
      # @param [Array] args array of arguments to convert to json and invoke remote method wtih
      def invoke(uri, rpc_method, *args)
        message = RJR::Messages::Request.new :method => rpc_method,
        :args   => args,
        :headers => @message_headers

        @@em.schedule {
          init_client(uri) do |c|
            c.stream { |msg| handle_message(msg.data, c) }

            c.send_msg message.to_s
          end
        }

        # TODO optional timeout for response ?
        # this cause resource leak
        #result = wait_for_result(message)

        result = wait_for_result_custom(message)

        if result.size > 2
          fail result[2]
        end
        return result[1]
      end

      private
      def wait_for_result_custom(message)
        res = nil
        message_id = message.msg_id
        @pending[message_id] = Time.now
        while res.nil?
          @response_lock.synchronize{
            # Prune messages that timed out
            if @timeout
              now = Time.now
              @pending.delete_if { |_, start_time| (now - start_time) > @timeout }
            end
            pending_ids = @pending.keys
            fail 'Timed out' unless pending_ids.include? message_id

            # Prune invalid responses
            @responses.keep_if { |response| @pending.has_key? response.first }
            res = @responses.find { |response| message.msg_id == response.first }
            if !res.nil?
              @responses.delete(res)
              @pending.delete(message_id)
            else
              @response_cv.wait @response_lock, @wait_interval
            end
          }
        end
        return res
      end

    end
  end
end

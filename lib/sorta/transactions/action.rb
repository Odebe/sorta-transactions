# frozen_string_literal: true

module Sorta
  module Transactions
    class Action
      def initialize(service_obj, opts)
        @service_obj = service_obj
        @opts        = opts
      end
    
      def run
        @service_obj.commit(@opts)
      end
    
      def redo
        @service_obj.rollback(@opts)
      end
    end
  end
end

# frozen_string_literal: true

module Sorta
  module Transactions
    module Service
      def self.included(mod)
        mod.extend Extended
        mod.include Included
        mod.prepend Prepended
      end

      module Extended
        def call(opts)
          new.call(opts)
        end
      end

      module Prepended
        attr_reader :metadata

        def initialize(**args)
          @metadata = {}
          super(args)
        end
      end
  
      module Included
        def call(opts)
          Sorta::Transactions::Action.new(self, opts)
        end

        def commit(_args)
          raise StandardError, 'abstract method'
        end

        def rollback(_args)
          raise StandardError, 'abstract method'
        end
      end
    end
  end
end

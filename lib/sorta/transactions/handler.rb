# frozen_string_literal: true

module Sorta
  module Transactions
    module Handler
      # TODO: custom method name api like
      # `include Sorta::Transactions::Handler[:do_transactions_please]`
      def self.included(mod)
        mod.prepend Yielder
      end

      module Yielder
        def call(**args)
          completed = []
          super(args) do |action|
            completed << action
            action.run
          rescue => e
            completed.each(&:redo)
            raise e
          end
        end
      end
    end
  end
end


module Bixby
  module ApiView
    class Check < ::ApiView::Base

      for_model ::Check

      def self.convert(obj)
        hash = attrs(obj, :all)
        hash[:name] = obj.command.name

        return hash
      end

    end # Check
  end # ApiView
end # Bixby
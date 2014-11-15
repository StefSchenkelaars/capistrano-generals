module Capistrano
  module Generals
    module Helpers

      def red text
        "\033[31m#{text}\033[0m"
      end

    end
  end
end

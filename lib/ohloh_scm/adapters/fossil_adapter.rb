module OhlohScm::Adapters
    class FossilAdapter < AbstractAdapter
        def english_name
            "Fossil"
        end
    end
end

require_relative 'fossil/validation'
require_relative 'fossil/cat_file'
require_relative 'fossil/commits'
require_relative 'fossil/token'
require_relative 'fossil/push'
require_relative 'fossil/pull'
require_relative 'fossil/head'
require_relative 'fossil/patch'


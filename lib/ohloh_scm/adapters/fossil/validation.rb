module OhlohScm::Adapters
    class FossilAdapter < AbstractAdapter

        def self.url_regex
            /^(http|https|ssh|file):\/{2,3}(\w+@)?[A-Za-z0-9_\-\.]+(:\d+)?\/[A-Za-z0-9_@\-\.\/\~\+]*$/
        end

        def self.public_url_regex
            /^(http|https|ssh|file):\/{2,3}(\w+@)?[A-Za-z0-9_\-\.]+(:\d+)?\/[A-Za-z0-9_\-\.\/\~\+]*$/
        end

        def normalize
            super
            @branch_name = 'trunk' if @branch_name.to_s == ''
            self
        end

    end
end

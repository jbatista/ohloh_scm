module OhlohScm::Adapters
    class FossilAdapter < AbstractAdapter

        def token_filename
            'ohloh_token'
        end

        def token_path
            File.join(self.url, token_filename)
        end

        def read_token
            token = nil
            if self.exist?
                begin
                    token = run("cd '#{url}' && fossil cat #{token_filename}").strip
                rescue RuntimeError => e
                    if e.message =~ /pathspec '#{token_filename}' did not match any file\(s\) known to fossil/
                        return nil
                    else
                        raise
                    end
                end
            end
            token
        end

        def write_token(token)
            if token and token.to_s.length > 0
                File.open(token_path, 'w') do |f|
                    f.write token.to_s
                end
            end
        end

    end
end


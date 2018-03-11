module OhlohScm::Adapters
    class FossilAdapter < AbstractAdapter

        def patch_for_commit(commit)
            parent_tokens(commit).map { |token|
                run("cd #{url} && fossil diff --to #{token} --from #{commit.token}")
            }.join("\n")
        end

    end
end


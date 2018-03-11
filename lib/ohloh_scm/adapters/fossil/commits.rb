module OhlohScm::Adapters
    class FossilAdapter < AbstractAdapter

        # Return the number of commits in the repository following the commit with SHA1 'after'.
        def commit_count(opts={})
            run("#{rev_list_command(opts)} | wc -l").to_i
        end

        # Return the SHA1 hash for every commit in the repository following the commit with SHA1 'after'.
        def commit_tokens(opts={}) 
            run(rev_list_command(opts)).split("\n")
        end

        def rev_list_command(opts={})
            after = opts[:after] ? "after #{opts[:after]}" : ""
            before = opts[:before] ? "before #{opts[:before]}" : ""
            limit = opts[:limit] ? "--limit #{opts[:limit]}" : ""

            "cd '#{url}' && fossil timeline -t ci -W 0 #{before} #{after} #{limit}"
        end

    end
end

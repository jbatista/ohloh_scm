module OhlohScm::Adapters
	class BzrAdapter < AbstractAdapter
		def exist?
			begin
				head_token.to_s.length > 0
			rescue
				logger.debug { $! }
				false
			end
		end

		def ls_tree(token)
      run("cd #{path} && bzr ls -V -r #{to_rev_param(token)}").split("\n")
		end

		def to_rev_param(r=nil)
			case r
			when nil
				1
			when Fixnum
				r.to_s
			when /^\d+$/
				r
			else
        "'revid:#{r.to_s}'"
			end
		end

		def is_merge_commit?(commit)
			parent_tokens(commit).size > 1
		end

    def export_tag(dest_dir, tag_name)
      run "cd '#{path}' && bzr export -r tag:#{tag_name} #{dest_dir}"
    end

		def export(dest_dir, token=head_token)
			# Unlike other SCMs, Bzr doesn't simply place the contents into dest_dir.
			# It actually *creates* dest_dir. Since it should already exist at this point,
			# first we have to delete it.
			Dir.delete(dest_dir) if File.exist?(dest_dir)

			run "cd '#{url}' && bzr export --format=dir -r #{to_rev_param(token)} '#{dest_dir}'"
		end

    def tags
      tag_strings = run("cd '#{url}' && bzr tags").split(/\n/)
      tag_strings.map do |tag_string|
        parse_tag_names_and_revision = tag_string.split(/\s+/)
        if parse_tag_names_and_revision.size > 1
          tag_name, rev = parse_tag_names_and_revision[0..-2].join(' '), parse_tag_names_and_revision.last
        else
          tag_name, rev = parse_tag_names_and_revision.first, nil
        end
        next if rev == '?' || tag_name == '....'
        time_string = run("cd '#{ url }' && bzr log -r #{ rev } | grep 'timestamp:' | sed 's/timestamp://'")
        [tag_name, rev, Time.parse(time_string)]
      end.compact
    end
	end
end

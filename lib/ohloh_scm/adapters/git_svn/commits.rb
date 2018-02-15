module OhlohScm::Adapters
  class GitSvnAdapter < AbstractAdapter
    def commit_count(opts={})
      cmd = "#{after_revision(opts)} | wc -l"
      git_svn_log(cmd: cmd, oneline: true).to_i
    end

    def commits(opts={})
      parsed_commits = []
      open_log_file(opts) do |io|
        parsed_commits = OhlohScm::Parsers::SvnParser.parse(io)
      end
      parsed_commits
    end

    def commit_tokens(opts={})
      cmd = "#{after_revision(opts)} | #{extract_revision_number}"
      git_svn_log(cmd: cmd, oneline: false).split
        .map(&:to_i)
    end

    def each_commit(opts={})
      commits(opts).each do |commit|
        yield commit
      end
    end

    private

    def open_log_file(opts={})
      cmd = "-v #{ after_revision(opts) } | #{string_encoder} > #{log_filename}"
      git_svn_log(cmd: cmd, oneline: false)
      File.open(log_filename, 'r') { |io| yield io }
    end

    def log_filename
      File.join('/tmp', url.gsub(/\W/,'') + '.log')
    end

    def after_revision(opts)
      next_token = opts[:after].to_i + 1
      next_head_token = head_token.to_i + 1
      "-r#{ next_token }:#{ next_head_token }"
    end

    def extract_revision_number
      "grep '^r[0-9].*|' | awk -F'|' '{print $1}' | cut -c 2-"
    end
  end
end

require 'json'

module OhlohScm::Parsers
	# This parser processes Fossil json timeline checkin generated Fossil json output.
	# This custom style provides additional information required by Ohloh.
	class FossilJsonParser < Parser
		def self.scm
			'fossil'
		end

		ANONYMOUS = "(no author)" unless defined?(ANONYMOUS)

        # before|after WHEN -v -n LIMIT
		def self.whatchanged
			"fossil json timeline checkin before now -v -n 1"
		end

		def self.internal_parse(io, opts)
            json = JSON.load(io)
            json["payload"]["timeline"].each do |ci|
                if ci["type"] == "checkin"
                    c = OhlohScm::Commit.new
                    c.token = ci["uuid"]
                    c.author_name = if ci["user"].nil? then ANONYMOUS else ci["user"] end
                    if c.author_name =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i then c.author_email = ci["user"] end
                    c.author_date = Time.at(ci["timestamp"]).utc
                    c.diffs = []
                    ci["files"].each do |file|
                        c.diffs << OhlohScm::Diff.new(:action => file["state"][0].upcase, :path => file["name"], :sha1 => file["uuid"], :parent_sha1 => file["parent"])
                    end
                    yield c
                end
            end
		end

	end
end


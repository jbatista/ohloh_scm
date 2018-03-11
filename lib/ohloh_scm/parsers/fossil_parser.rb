module OhlohScm::Parsers
    class FossilParser < Parser

        def self.scm
            'fossil'
        end

        ANONYMOUS = "(no author)" unless defined?(ANONYMOUS)

        def self.parse_tstamp(date, time, tzoffset = '+0000')
            t = Time.parse(date.to_s + ' ' + time.to_s + ' ' + tzoffset.to_s).utc rescue Time.at(0).utc
        end

        def self.splitmsg(msg, e)
            if msg =~ /^(\*[A-Z]+\*\s)?(.+)(\s\(user:\s(.+)\stags:\s(.+)\))$/
                e.message = $2
                e.author_name = $4
            end
            return e
        end

		def self.internal_parse(io, opts)
            e = nil
            date = nil
            msg = nil

			io.each do |line|
				line.chomp!

                if line =~ /^\+\+\+ end of timeline \(\d+\) \+\+\+$/
                    yield splitmsg(msg,e) if e
                    return
                elsif line =~ /^--- line limit \(\d+\) reached ---$/
                    yield splitmsg(msg,e) if e
                    return
                elsif line =~ /^=== (\d{4}[\.\-\/]\d{2}[\.\-\/]\d{2}) ===$/
                    date = $1
                    yield splitmsg(msg,e) if e and date
				elsif line =~ /^(\d{2}[:]\d{2}[:]\d{2}) \[([0-9a-f]{10})\] (.+)$/
                    yield splitmsg(msg,e) if e and date
                    e = OhlohScm::Commit.new
                    e.token = $2.to_s # TODO this is only substring of hash; get full hash
                    e.author_date = parse_tstamp(date, $1)
                    msg = $3.to_s
                    e.message = $4.to_s
                    e.diffs = []
				elsif line =~ /^         (.+)$/
                    e.message += $1.to_s
				elsif line =~ /^   ([A-Z]+) (.+)$/
                    e.diffs << OhlohScm::Diff.new(:action => $1.to_s[0], :path => $2.to_s)
                else 
					raise RuntimeError.new("Unparsable line: #{line.to_s}")
				end
			end

            yield e if e
		end

    end
end


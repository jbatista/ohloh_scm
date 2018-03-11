require_relative '../test_helper'

module OhlohScm::Parsers
    class FossilStyledParserTest < OhlohScm::Test

        def test_empty_array
            assert_equal([], FossilStyledParser.parse(''))
        end

        def test_log_parser_default
sample_log = <<-SAMPLE
=== 2000-05-29 ===
18:32:16 [1d3286702c] :-) (CVS 4) (user: drh tags: trunk)
   DELETED Makefile.in
   EDITED www/c_interface.tcl
18:20:15 [9e36a6014b] :-) (CVS 3) (user: drh tags: trunk)
   ADDED www/c_interface.tcl
   EDITED www/index.tcl
   EDITED www/sqlite.tcl
--- line limit (2) reached ---
SAMPLE
            commits = FossilStyledParser.parse(sample_log)

            assert commits
            assert_equal 2, commits.size

            assert_equal '1d3286702c', commits[0].token
            assert_equal 'drh', commits[0].author_name
            assert_equal nil, commits[0].author_email
            assert_equal Time.utc(2000, 5, 29, 18, 32, 16), commits[0].author_date
            assert_equal ':-) (CVS 4)', commits[0].message
            assert_equal 2, commits[0].diffs.size
            assert_equal 'D', commits[0].diffs[0].action
            assert_equal 'Makefile.in', commits[0].diffs[0].path
            assert_equal nil, commits[0].diffs[0].parent_sha1
            assert_equal nil, commits[0].diffs[0].sha1
            assert_equal 'E', commits[0].diffs[1].action
            assert_equal 'www/c_interface.tcl', commits[0].diffs[1].path
            assert_equal nil, commits[0].diffs[1].parent_sha1
            assert_equal nil, commits[0].diffs[1].sha1

            assert_equal '9e36a6014b', commits[1].token
            assert_equal 'drh', commits[1].author_name
            assert_equal nil, commits[1].author_email
            assert_equal Time.utc(2000, 5, 29, 18, 20, 15), commits[1].author_date
            assert_equal ':-) (CVS 3)', commits[1].message
            assert_equal 3, commits[1].diffs.size
            assert_equal 'A', commits[1].diffs[0].action
            assert_equal 'www/c_interface.tcl', commits[1].diffs[0].path
            assert_equal nil, commits[1].diffs[0].parent_sha1
            assert_equal nil, commits[1].diffs[0].sha1
            assert_equal 'E', commits[1].diffs[1].action
            assert_equal 'www/index.tcl', commits[1].diffs[1].path
            assert_equal nil, commits[1].diffs[1].parent_sha1
            assert_equal nil, commits[1].diffs[1].sha1
            assert_equal 'E', commits[1].diffs[2].action
            assert_equal 'www/sqlite.tcl', commits[1].diffs[2].path
            assert_equal nil, commits[1].diffs[2].parent_sha1
            assert_equal nil, commits[1].diffs[2].sha1
        end

    end
end


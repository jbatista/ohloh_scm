require_relative '../test_helper'

module OhlohScm::Parsers
    class FossilJsonParserTest < OhlohScm::Test

        def test_log_parser_default
sample_log = <<-SAMPLE
{
    "fossil":"188a0e290419211f7928be4e808d58331c9fdd742d73caa7818c2ac0b66b605c",
    "timestamp":1520895209,
    "command":"timeline/checkin",
    "procTimeUs":6045766,
    "procTimeMs":6045,
    "payload":{
        "limit":3,
        "timeline":[
                        {
                                "type":"checkin",
                                "uuid":"1d3286702cf267857190e6082db15ba4132453d7",
                                "isLeaf":false,
                                "timestamp":959625136,
                                "user":"drh",
                                "comment":":-) (CVS 4)",
                                "parents":["9e36a6014b9e8298d8fff71f0f1e3fd5610c30bd"],
                                "tags":["trunk"],
                                "files":[
                                        {
                                                "name":"Makefile.in",
                                                "uuid":"f145e2ccfb1bb63e28362fef46bd5e6b27254aec",
                                                "parent":"bab6ff58d847d1b9eb25d4cbf671e4ebd0c74256",
                                                "size":3446,
                                                "state":"modified",
                                                "downloadPath":"/raw/Makefile.in?name=f145e2ccfb1bb63e28362fef46bd5e6b27254aec"
                                        },
                                        {
                                                "name":"www/c_interface.tcl",
                                                "uuid":"f875864edf7974157d1c257ca08de854660882a5",
                                                "parent":"851921790368665e040d15eb33a3ca569de97643",
                                                "size":5798,
                                                "state":"modified",
                                                "downloadPath":"/raw/www/c_interface.tcl?name=f875864edf7974157d1c257ca08de854660882a5"
                                        }
                                ]
                        },
                        {
                                "type":"checkin",
                                "uuid":"9e36a6014b9e8298d8fff71f0f1e3fd5610c30bd",
                                "isLeaf":false,
                                "timestamp":959624415,
                                "user":"drh",
                                "comment":":-) (CVS 3)",
                                "parents":["53841c66c699665e83c933627bbe7a193cfccb6b"],
                                "tags":["trunk"],
                                "files":[
                                        {
                                                "name":"www/c_interface.tcl",
                                                "uuid":"851921790368665e040d15eb33a3ca569de97643",
                                                "size":5391,
                                                "state":"added",
                                                "downloadPath":"/raw/www/c_interface.tcl?name=851921790368665e040d15eb33a3ca569de97643"
                                        },
                                        {
                                                "name":"www/index.tcl",
                                                "uuid":"c10c625192ee9f19f186f65b90196c9cabe30936",
                                                "parent":"3785d894fe5fc0976bb7400ab307b4aef34fbf60",
                                                "size":4353,
                                                "state":"modified",
                                                "downloadPath":"/raw/www/index.tcl?name=c10c625192ee9f19f186f65b90196c9cabe30936"
                                        },
                                        {
                                                "name":"www/sqlite.tcl",
                                                "uuid":"69674d9b8344870de7a6f059169311ebc54111f8",
                                                "parent":"c24416391358ade2e74fffeaca8eb0b0e8b1d1ac",
                                                "size":13329,
                                                "state":"modified",
                                                "downloadPath":"/raw/www/sqlite.tcl?name=69674d9b8344870de7a6f059169311ebc54111f8"
                                        }
                                ]
                        },
                        {
                                "type":"checkin",
                                "uuid":"704b122e5308587b60b47a5c2fff40c593d4bf8f",
                                "isLeaf":false,
                                "timestamp":959609760,
                                "user":"drh",
                                "comment":"initial empty check-in",
                                "tags":["trunk"]
                        }
        ]
    }
}
SAMPLE
            commits = FossilJsonParser.parse(sample_log)

            assert commits
            assert_equal 3, commits.size

            assert_equal '9e36a6014b9e8298d8fff71f0f1e3fd5610c30bd', commits[0].token
            assert_equal 'drh', commits[0].author_name
            assert_equal nil, commits[0].author_email
            assert_equal Time.utc(2000, 5, 29, 18, 20, 15), commits[1].author_date
            assert_equal ':-) (CVS 4)', commits[0].message
            assert_equal 3, commits[0].diffs.size
            assert_equal 'M', commits[0].diffs[0].action
            assert_equal 'Makefile.in', commits[0].diffs[0].path
            assert_equal 'bab6ff58d847d1b9eb25d4cbf671e4ebd0c74256', commits[0].diffs[0].parent_sha1
            assert_equal 'f145e2ccfb1bb63e28362fef46bd5e6b27254aec', commits[0].diffs[0].sha1
            assert_equal 'M', commits[0].diffs[1].action
            assert_equal 'www/c_interface.tcl', commits[0].diffs[1].path
            assert_equal '851921790368665e040d15eb33a3ca569de97643', commits[0].diffs[1].parent_sha1
            assert_equal 'f875864edf7974157d1c257ca08de854660882a5', commits[0].diffs[1].sha1

            assert_equal '9e36a6014b9e8298d8fff71f0f1e3fd5610c30bd', commits[1].token
            assert_equal 'drh', commits[1].author_name
            assert_equal nil, commits[1].author_email
            assert_equal Time.utc(2000, 5, 29, 18, 20, 15), commits[1].author_date
            assert_equal ':-) (CVS 3)', commits[1].message
            assert_equal 3, commits[1].diffs.size
            assert_equal 'A', commits[1].diffs[0].action
            assert_equal 'www/c_interface.tcl', commits[1].diffs[0].path
            assert_equal nil, commits[1].diffs[0].parent_sha1
            assert_equal '851921790368665e040d15eb33a3ca569de97643', commits[1].diffs[0].sha1
            assert_equal 'M', commits[1].diffs[1].action
            assert_equal 'www/index.tcl', commits[1].diffs[1].path
            assert_equal '3785d894fe5fc0976bb7400ab307b4aef34fbf60', commits[1].diffs[1].parent_sha1
            assert_equal 'c10c625192ee9f19f186f65b90196c9cabe30936', commits[1].diffs[1].sha1
            assert_equal 'A', commits[1].diffs[2].action
            assert_equal 'www/sqlite.tcl', commits[1].diffs[2].path
            assert_equal 'c24416391358ade2e74fffeaca8eb0b0e8b1d1ac', commits[1].diffs[2].parent_sha1
            assert_equal '69674d9b8344870de7a6f059169311ebc54111f8', commits[1].diffs[2].sha1

            assert_equal '704b122e5308587b60b47a5c2fff40c593d4bf8f', commits[2].token
            assert_equal 'drh', commits[2].author_name
            assert_equal nil, commits[2].author_email
            assert_equal Time.utc(2000, 5, 29, 14, 16, 00), commits[2].author_date
            assert_equal 'initial empty check-in', commits[2].message
            assert_equal 0, commits[2].diffs.size
        end

    end
end


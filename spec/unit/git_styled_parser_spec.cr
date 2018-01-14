require "../spec_helper"

describe "GitStyledParser" do

  it "empty_array" do
    GitStyledParser.parse("").should eq([])
  end

  it "log_parser_nil_date" do
sample_log = <<-SAMPLE
__BEGIN_COMMIT__
Commit: 1df547800dcd168e589bb9b26b4039bff3a7f7e4
Author: Jason Allen
AuthorEmail: jason@ohloh.net
Date:
__BEGIN_COMMENT__
  moving COPYING

__END_COMMENT__
SAMPLE

    commits = GitStyledParser.parse(sample_log)
    commits.size.should eq(1)
    commits[0].author_date.should eq(Time.utc(1970,1,1,0,0,0))
  end

  it "log_parser_bogus_date" do
sample_log = <<-SAMPLE
__BEGIN_COMMIT__
Commit: 1df547800dcd168e589bb9b26b4039bff3a7f7e4
Author: Jason Allen
AuthorEmail: jason@ohloh.net
Date: Mon, Jan 01 2012 05:00:00 -0500
__BEGIN_COMMENT__
  moving COPYING

__END_COMMENT__
SAMPLE

    commits = GitStyledParser.parse(sample_log)
    commits.size.should eq(1)
    commits[0].author_date.should eq(Time.utc(1970,1,1,0,0,0))
  end

  it "log_parser_default" do
sample_log = <<SAMPLE
__BEGIN_COMMIT__
Commit: 1df547800dcd168e589bb9b26b4039bff3a7f7e4
Author: Jason Allen
AuthorEmail: jason@ohloh.net
Date:   Fri, 14 Jul 2006 16:07:15 -0700
__BEGIN_COMMENT__
moving COPYING

__END_COMMENT__

:000000 100755 0000000000000000000000000000000000000000 a7b13ff050aed1191c45d7a5db9a50edcdc5755f A	COPYING

__BEGIN_COMMIT__
Commit: 2e9366dd7a786fdb35f211fff1c8ea05c51968b1
Author: Robin Luckey
AuthorEmail: robin@ohloh.net
Date:   Sun, 11 Jun 2006 11:34:17 -0700
__BEGIN_COMMENT__
added some documentation and licensing info

__END_COMMENT__

:100644 100644 d4a46caf1891fccebb726504f34794a0ca5d2e42 41dc0d12cb9eaa30e57aa7126b1227ba320ad297 M	README
:100644 000000 41dc0d12cb9eaa30e57aa7126b1227ba320ad297 0000000000000000000000000000000000000000 D	helloworld.c
SAMPLE

    commits = GitStyledParser.parse(sample_log)

    commits.should be_truthy
    commits.size.should eq(2)

    commits[0].token.should eq("1df547800dcd168e589bb9b26b4039bff3a7f7e4")
    commits[0].author_name.should eq("Jason Allen")
    commits[0].author_email.should eq("jason@ohloh.net")
    commits[0].message.should eq("moving COPYING\n")
    commits[0].author_date.should eq(Time.utc(2006,7,14,23,7,15))
    commits[0].diffs.size.should eq(1)

    commits[0].diffs[0].action.should eq("A")
    commits[0].diffs[0].path.should eq("COPYING")

    commits[1].token.should eq("2e9366dd7a786fdb35f211fff1c8ea05c51968b1")
    commits[1].author_name.should eq("Robin Luckey")
    commits[1].author_email.should eq("robin@ohloh.net")
    commits[1].message.should eq("added some documentation and licensing info\n") # Note \n at end of comment
    commits[1].author_date.should eq(Time.utc(2006,6,11,18,34,17))
    commits[1].diffs.size.should eq(2)

    commits[1].diffs[0].action.should eq("M")
    commits[1].diffs[0].path.should eq("README")
    commits[1].diffs[1].action.should eq("D")
    commits[1].diffs[1].path.should eq("helloworld.c")
  end

end

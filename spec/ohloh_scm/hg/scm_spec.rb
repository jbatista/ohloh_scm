require 'spec_helper'

describe 'Hg::Scm' do
  it 'must pull hg repository and clean up non .hg files' do
    with_hg_repository('hg') do |src|
      tmpdir do |dir|
        dest = OhlohScm::Factory.get_core(scm_type: :hg, url: dir)
        dest.status.wont_be :exist?

        dest.scm.pull(src.scm, TestCallback.new)
        dest.status.must_be :exist?
        Dir.entries(dir).sort.must_equal ['.', '..', '.hg']

        # Commit some new code on the original and pull again
        run_p "cd '#{src.scm.url}' && touch foo && hg add foo && hg commit -u test -m test"
        src.activity.commits.last.message.must_equal "test\n"

        dest.scm.pull(src.scm, TestCallback.new)
        Dir.entries(dir).sort.must_equal ['.', '..', '.hg']
      end
    end
  end
end

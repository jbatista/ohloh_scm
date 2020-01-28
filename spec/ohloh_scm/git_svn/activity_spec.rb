require 'spec_helper'
require 'mocha'

describe 'GitSvn::Activity' do
  it 'must return all commit tokens' do
    with_git_svn_repository('git_svn') do |git_svn|
      git_svn.activity.commit_tokens.must_equal [1, 2, 3, 5]
      git_svn.activity.commit_tokens(after: 2).must_equal [3, 5]
    end
  end

  it 'must return commits' do
    with_git_svn_repository('git_svn') do |git_svn|
      git_svn.activity.commits.map(&:token).must_equal [1, 2, 3, 5]
      git_svn.activity.commits(after: 2).map(&:token).must_equal [3, 5]
      git_svn.activity.commits(after: 7).map(&:token).must_equal []
    end
  end

  it 'must iterate each commit' do
    with_git_svn_repository('git_svn') do |git_svn|
      commits = []
      git_svn.activity.each_commit { |c| commits << c }
      git_svn.activity.commits.map(&:token).must_equal [1, 2, 3, 5]
    end
  end

  it 'must return total commit count' do
    with_git_svn_repository('git_svn') do |git_svn|
      git_svn.activity.commit_count.must_equal 4
      git_svn.activity.commit_count(after: 2).must_equal 2
    end
  end

  describe 'cat' do
    let(:commit_1) { OhlohScm::Commit.new(token: 1) }
    let(:hello_diff) { OhlohScm::Diff.new(path: 'helloworld.c') }

    it 'cat_file' do
      with_git_svn_repository('git_svn') do |git_svn|
        expected = <<-EXPECTED.gsub(/^\s+/, '')
          /* Hello, World! */
          #include <stdio.h>
          main()
          {
            printf("Hello, World!\\n");
          }
        EXPECTED

        git_svn.activity.cat_file(commit_1, hello_diff)
               .delete("\t").strip.must_equal expected.strip
      end
    end

    it 'cat_file_with_non_existent_token' do
      with_git_svn_repository('git_svn') do |git_svn|
        assert git_svn.activity.cat_file(OhlohScm::Commit.new(token: 999), hello_diff)
      end
    end

    it 'cat_file_with_invalid_filename' do
      with_git_svn_repository('git_svn') do |git_svn|
        -> { git_svn.activity.cat_file(commit_1, OhlohScm::Diff.new(path: 'invalid')) }.must_raise(RuntimeError)
      end
    end

    it 'cat_file_parent' do
      with_git_svn_repository('git_svn') do |git_svn|
        expected = <<-EXPECTED.gsub(/^\s+/, '')
          /* Hello, World! */
          #include <stdio.h>
          main()
          {
            printf("Hello, World!\\n");
          }
        EXPECTED

        commit = OhlohScm::Commit.new(token: 2)
        git_svn.activity.cat_file_parent(commit, hello_diff).delete("\t").must_equal expected.strip
      end
    end

    it 'cat_file_parent_with_first_token' do
      with_git_svn_repository('git_svn') do |git_svn|
        assert git_svn.activity.cat_file(commit_1, hello_diff)
      end
    end
  end
end

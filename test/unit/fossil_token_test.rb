require_relative '../test_helper'

module OhlohScm::Adapters
    class FossilTokenTest < OhlohScm::Test

        def test_no_token_returns_nil
            OhlohScm::ScratchDir.new do |dir|
                fossil = FossilAdapter.new(:url => dir).normalize
                assert !fossil.read_token
                fossil.init_db
                asser !fossil.read_token
            end
        end

        def test_write_and_read_token
            OhlohScm::ScratchDir.new do |dir|
                fossil = FossilAdapter.new(:url => dir).normalize
                fossil.init_db
                fossil.write_token("FOO")
                assert !fossil.read_token # Token not valid until committed
                fossil.commit_all(OhlohScm::Commit.new)
                assert_equal "FOO", fossil.read_token
            end
        end

        def test_commit_all_includes_write_token
            OhlohScm::ScratchDir.new do |dir|
                fossil = FossilAdapter.new(:url => dir).normalize
                fossil.init_db
                c = OhlohScm::Commit.new
                c.token = "BAR"
                fossil.commit_all(c)
                assert_equal c.token, git.read_token
            end
        end

        def test_read_token_encoding
            with_fossil_repository('fossil_with_invalid_encoding') do |fossil|
                assert_nothing_raised do
                    fossil.read_token
                end
            end
        end

    end
end


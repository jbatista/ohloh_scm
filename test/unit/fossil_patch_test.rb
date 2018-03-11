require_relative '../test_helper'

module OhlohScm::Adapters
    class FossilPatchTest < OhlohScm::Test

        def test_patch_for_commit
            with_fossil_repository('fossil') do |repo|
                commit = repo.verbose_commit('b6e9220c3cabe53a4ed7f32952aeaeb8a822603d')
                data = File.read(File.join(DATA_DIR, 'fossil_patch.diff'))
                assert_equal data, repo.patch_for_commit(commit)
            end
        end

    end
end


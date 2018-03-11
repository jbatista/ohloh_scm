require_relative '../test_helper'

module OhlohScm::Adapters
    class FossilCatFileTest < OhlohScm::Test

        def test_cat_file
            with_fossil_repository('fossil') do |fossil|
expected = <<-EXPECTED
/* Hello, World! */
#include <stdio.h>
main()
{
    printf("Hello, World!\\n");
}
EXPECTED
                assert_equal expected, fossil.cat_file(nil, OhlohScm::Diff.new(:sha1 => '4c734ad53b272c9b3d719f214372ac497ff6c068'))
            end
        end

    end
end

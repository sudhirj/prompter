require 'test_helper'

class ScorerTest < ActiveModel::TestCase

	class ExampleScorer
		include Scorer
	end

	test "tokenization" do
		sc = ExampleScorer.new
		tokens = sc.tokenize ['abc', 'xyz']
		assert_equal ['a', 'ab', 'abc', 'x', 'xy', 'xyz'].to_set, tokens
	end



end

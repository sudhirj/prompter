require 'test_helper'

class ScorerTest < ActiveModel::TestCase
	test "simple whole word scoring" do
		sc = Scorer.new([
			{weight: 4, terms: ['a', 'b']},
			{weight: 2, terms: ['c', 'd']}
		])
		assert_in_delta 2.fdiv(6), sc.rank('a'), 0.001
		assert_in_delta 1.fdiv(6), sc.rank('c'), 0.001
	end

	test "partial word scoring" do
		sc = Scorer.new([
			{weight: 4, terms: ['ab', 'efwx']},
			{weight: 2, terms: ['eflm', 'gh']}
		])
		assert_in_delta 1.fdiv(6), sc.rank('a'), 0.001
		assert_in_delta 2.fdiv(6), sc.rank('ab'), 0.001
		assert_in_delta 1.fdiv(12), sc.rank('g'), 0.001
		assert_in_delta [1.fdiv(6), 1.fdiv(12)].sum.fdiv(2), sc.rank('ef'), 0.001

		assert sc.rank('a') > sc.rank('b')
		assert sc.rank('ab') > sc.rank('ef')
		assert_equal sc.rank('ab'), sc.rank('efwx')
		assert_equal sc.rank('eflm'), sc.rank('gh')
		assert sc.rank('ef') > sc.rank('g')
		assert sc.rank('efwx') > sc.rank('gh')
		assert sc.rank('gh') > sc.rank('e')
	end

	test "tokenization" do
		sc = Scorer.new([
			{weight: 4, terms: ['ab', 'cd']},
			{weight: 2, terms: ['ef', 'gh']}
		])
		assert_equal sc.tokenize, ['a', 'ab', 'c', 'cd', 'e', 'ef', 'g', 'gh'].to_set
		assert_equal sc.tokens, sc.tokenize.map{|t| {token: t, weight: sc.rank(t)}}
	end
end

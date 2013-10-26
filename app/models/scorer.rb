class Scorer
	TermSet = Struct.new(:weight, :terms) do
		def cleaned_terms
  		terms.flat_map{|t| t.parameterize.split('-')}.to_set
  	end

  	def token_weight total_weight
  		weight.fdiv(total_weight * terms.size)
  	end

  	def tokens total_weight
  		cleaned_terms.map do |term|
  			Token.new term, token_weight(total_weight)
  		end
  	end
	end

	Token = Struct.new(:token, :weight)

  def initialize corpus
  	@corpus = corpus.map{|c| TermSet.new(c[:weight], c[:terms])}
  	@total_weight = @corpus.sum {|c| c.weight}
  	@weighted_tokens = @corpus.flat_map{ |c| c.tokens @total_weight }
  end

  def rank query
  	scores = @weighted_tokens.map do |wt|
  		length_score = wt.token.starts_with?(query) ? query.length.fdiv(wt.token.length) : 0
  		length_score * wt.weight
  	end
  	score_count = scores.count{|s| s > 0}
  	return 0 unless score_count > 0
  	scores.sum / score_count
  end

  def tokenize
    @corpus.flat_map{|c| c.cleaned_terms.to_a}.flat_map do |str|
      (1..str.length).map do |len|
        str.slice 0, len
      end
    end.to_set
  end

  def tokens
    tokenize.map{|t| {token: t, weight: rank(t)}}
  end

end
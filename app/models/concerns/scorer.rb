module Scorer
  extend ActiveSupport::Concern

  def tokenize strs
  	strs.flat_map do |str|
  		(1..str.length).map do |len|
  			str.slice 0, len
  		end
  	end
  end
end
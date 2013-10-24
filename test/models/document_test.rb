require 'test_helper'

class DocumentTest < ActiveModel::TestCase
	include ActiveModel::Lint::Tests

	def setup
		@model = Document.new
		@redis = Redis.new
	end

	test "putting a document stores it's data" do
		doc = Document.new({
			id: "abc1",
			data: {hello: 'world'}
		})
		doc.put
		assert_equal({"hello" => 'world'}, MessagePack.unpack(@redis.get(doc.key)))
	end

	test "key generation" do
		doc = Document.new id: 'abc', type: 'gen'
		assert_equal doc.key, "#{Rails.env}:gen:abc"
	end
end

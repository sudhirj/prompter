class Document
	extend ActiveModel::Naming
	include ActiveModel::Validations

	def to_model
		self
	end

	def persisted?
		false
	end

	def to_key
		nil
	end

	def to_param
	end

	def to_partial_path() '' end

	def self.put
	end

	def initialize values = {}
		@id = values[:id]
		@type = values[:type]
		@data = values[:data]
	end

	def key
		[Rails.env, @type, @id].join(':')
	end

	def put
		writis.set key, @data.to_msgpack
	end

	def writis
		Redis.new
	end


end
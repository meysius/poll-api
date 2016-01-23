ActiveSupport.on_load(:active_model_serializers) do
	# This prevents generating root nodes in the json responses
	ActiveModel::Serializer.root = false
	ActiveModel::ArraySerializer.root = false
end
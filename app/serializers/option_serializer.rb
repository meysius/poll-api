class OptionSerializer < ActiveModel::Serializer
	attributes :id, :text, :votes_count

	def votes_count
		object.voters.size
	end
end

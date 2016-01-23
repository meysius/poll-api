class Poll < ActiveRecord::Base
	belongs_to(:user)
	has_many(:options)

	def init(creator_email, question, option_texts)
		self.user = User.find_by_email(creator_email)
		for text in option_texts
			self.options << Option.new(:text => text)
		end
		self.question = question
	end

	def serialize_for_user(user_email)
		result = PollSerializer.new(self).serializable_hash
		result[:options] = ActiveModel::ArraySerializer.new(self.options).serializable_object
		
		user = User.find_by_email(user_email)
		if (user.nil?)
			result[:user_choice] = nil
		else
			option = Option.user_choice(user.id, self.id)
			if (option.nil?)
				result[:user_choice] = nil	
			else
				result[:user_choice] = option.id	
			end
			
		end
		return result.to_json
	end

end

class User < ActiveRecord::Base
	has_many(:polls)
	has_and_belongs_to_many(:voted_options, :class_name => 'Option', :join_table => 'voted_options_voters')
	has_secure_password

	def vote(poll, option)
		# delete my previous vote if exists
		previous_choice = Option.user_choice(self.id, poll.id)
		unless previous_choice.nil?
			self.voted_options.delete(previous_choice)	
		end
		# store my new vote
		self.voted_options << option
		self.save
	end

	def register
		already_registered = User.find_by_email(email)
		unless already_registered.nil?
			raise 'This email is already registered.'
		end
		self.save
	end

	def login(given_password)
		hmac_secret = 'IL2MzjZ0Wvu0EGDZa2kyQkBVugUhLGbpk1pbJUPzavxHT7EbnsuNunolvJdtBOl'
		if authenticate(given_password)
			payload = {:email => self.email}
			return JWT.encode payload, hmac_secret, 'HS512'
		else
			raise 'Invalid password.'
		end
	end
end
class Option < ActiveRecord::Base
	belongs_to(:poll)
	has_and_belongs_to_many(:voters, :class_name => 'User', :join_table => 'voted_options_voters')

	def self.user_choice(user_id, poll_id)
		Option.joins(:voters).joins(:poll).where(:voted_options_voters => {:user_id => user_id}, :polls => {:id => poll_id}).first
	end
end

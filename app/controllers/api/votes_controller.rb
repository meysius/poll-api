class Api::VotesController < ApplicationController
	before_action(:confirm_logged_in, {:only => [:create]})

	def create
		user = User.find_by_email(@user_email)
		poll = Poll.find(create_vote_params[:poll_id])
		option = Option.find(create_vote_params[:user_choice])
		user.vote(poll, option)
		render(:nothing => true, :status => 200)
	end

	def create_vote_params
		params.permit(:poll_id, :user_choice)
	end
end

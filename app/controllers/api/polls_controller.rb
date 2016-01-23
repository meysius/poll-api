class Api::PollsController < ApplicationController
	before_action(:confirm_logged_in, {:only => [:create]})
	before_action(:check_logged_in, {:only => [:show]})

	def index
		render(:json => Poll.all, :status => 200)
	end

	def create
		p = Poll.new
		p.init(@user_email, create_poll_params[:question], create_poll_params[:options])
		p.save
		render(:nothing => true, :status => 200)
	end

	def show
		found = Poll.find_by_id(params[:id])
		render(:json => found.serialize_for_user(@user_email), :status => 200)
	end

	def update
		puts params	
	end

	def create_poll_params
		params.permit(:question, :options => [])
	end
end

class Api::UsersController < ApplicationController
	def create
		new_user = User.new(params.permit(:email, :password))
		begin
			new_user.register
			render(:json => {:status => 'success'}, :status => 200)
		rescue Exception => e
			render(:json => {:status => 'error', :message => e.message}, :status => 200)	
		end
	end
end
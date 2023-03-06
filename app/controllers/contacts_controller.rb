class ContactsController < ApplicationController
	def new
		@contact = Contact.new
	end

	def create
		@contact = Contact.new(params[:contact])
		@contact.request = request
		if @contact.deliver
			flash[:notice] = 'Message successfully sent!'
			redirect_to root_path
		else
			flash[:alert] = 'Could not send message, please try again'
			render :new, status: :unprocessable_entity
		end
	end
end

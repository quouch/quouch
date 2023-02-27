class ContactsController < ApplicationController
	def new
		@contact = Contact.new
	end

	def create
		@contact = Contact.new(params[:contact])
		@contact.request = request
		if @contact.deliver
			flash[:notice] = 'Message successfully sent!'
		else
			flash[:error] = 'Could not send message'
			render :new, status: :unprocessable_entity
		end
	end
end

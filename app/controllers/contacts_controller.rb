class ContactsController < ApplicationController
	skip_before_action :authenticate_user!

	def new
		@contact = Contact.new
	end

	def code
		@contact = Contact.new
	end

	def report
		@contact = Contact.new
	end

	def create
		@contact = Contact.new(contact_params)
		@contact.request = request

		if @contact.deliver
			flash[:notice] = 'Message successfully sent!'
			redirect_to root_path
		else
			flash[:alert] = 'Could not send message, please try again'
			render_response
		end
	end

	 private

	def contact_params
		params.require(:contact).permit(:type, other_allowed_parameters)
	end

	def render_response
		if params[:contact][:type] == 'code'
			render :code, status: :unprocessable_entity
		else
			render :new, status: :unprocessable_entity
		end
	end
end

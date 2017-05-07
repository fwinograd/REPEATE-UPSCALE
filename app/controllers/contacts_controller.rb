class ContactsController < ApplicationController
  # GET request to /contact-us
  # show new contact form
  def new
    @contact = Contact.new
  end
  # POST request to /contacts
def create
  # mass asignment of form fields into Contact object
  @contact = Contact.new(contact_params)
  # save the contact object to the database
  if @contact.save
    # store form fields via parameters, into variables.
    name = params[:contact][:name]
    email = params[:contact][:email]
    body = params[:contact][:comments]
    # plug variables into contact mailer and send email
    ContactMailer.contact_email(name, email, body).deliver
    # store message in flash hash and redirect back to form
    flash[:success] = "Message sent."
    redirect_to new_contact_path
  # if contact object doesn't save, store error message in flash hash
  else
     flash[:danger] = @contact.errors.full_messages.join(", ")
     redirect_to new_contact_path
  end
end


  private
    # to collect data from Form, we have to use this method and white list them..
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end
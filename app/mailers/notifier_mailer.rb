class NotifierMailer < Merb::MailController

  def comment_email
    @comment = params[:comment]
    @node = params[:node]
    render_mail
  end
  
end

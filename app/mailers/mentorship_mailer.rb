class MentorshipMailer < ActionMailer::Base 
	default from: 'notifications@redchairpgh.com'

    def acceptance_email_to_mentee
        @mentor = params[:mentor]
        @mentee = params[:mentee]
        mail(to: @mentee.email, subject: 'You have a new mentor!')
    end

    def acceptance_email_to_mentor
        @mentor = params[:mentor]
        @mentee = params[:mentee]
        mail(to: @mentor.email, subject: 'You have a new mentee!')
    end

	def tester
		mail(to: 'mwilson@fivestardev.com', subject: 'tester email')
	end
end
        

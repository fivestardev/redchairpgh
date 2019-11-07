class MentorshipMailer < ActionMailer::Base 
	default from: 'notifications@redchairpgh.com'

    def acceptance_email_to_mentee
		@mentor = User.find(params[:mentor][:user_id])
		@mentee = User.find(params[:mentee][:user_id])
        mail(to: @mentee.email, subject: 'A mentor has requested contact in the RedChairPGH Mentor Site!')
    end

    def acceptance_email_to_mentor
		@mentor = User.find(params[:mentor][:user_id])
		@mentee = User.find(params[:mentee][:user_id])
        mail(to: @mentor.email, subject: 'You have a new mentee request in the RedChairPGH Mentor Site!')
    end

	def tester
		mail(to: 'mwilson@fivestardev.com', subject: 'tester email')
	end
end
        

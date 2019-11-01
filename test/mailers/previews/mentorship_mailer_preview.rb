class MentorshipMailerPreview < ActionMailer::Preview
	def acceptance_email_to_mentor
		MentorshipMailer.with(mentor: {}).acceptance_email_to_mentor.deliver_now
	end
end

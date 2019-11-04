class Mentee < ApplicationRecord

	validates :mentor_role, presence: true
	validates :mentor_gender, presence: true
	validates :comm_frequency, presence: true
	validates :skill_1, presence: true
	validates :skill_2, presence: true
	validates :skill_3, presence: true
    
	# Relationships
	belongs_to :user
	has_many :mentorships
	has_many :mentors, through: :mentorships

    scope :for_user, -> (user_id) { where('user_id = ?', user_id) }
	
	ROLE = [['Nurturer', 'Nurturer'],['Colleague', 'Colleague'],['Sounding board', 'Sounding board'], ['Motivator','Motivator']]
	IMPACT = [['Knowledge of professional etiquette and standards of personal presentation', 'Knowledge of professional etiquette and standards of personal presentation'],['Knowledge of career field', 'Knowledge of career field'],['Expanded social support network', 'Expanded social support network'], ['Increased self-confidence','Increased self-confidence'],['Improved communication skills','Improved communication skills'],['Increased professional network','Increased professional network'], ['Improved supervisory/leadership skills','Improved supervisory/leadership skills'],['Career planning/progression & professional development','Career planning/progression & professional development'],['Work\life balance','Work\life balance'],['Negotiation tactics','Negotiation tactics'],['Developing technical skills','Developing technical skills'], ['Entrepreneurship','Entrepreneurship']]
	COMMUNICATION_FREQ = [['Biweekly', 'Biweekly'],['Monthly', 'Monthly'],['Bimonthly', 'Bimonthly'], ['Quarterly','Quarterly'],  ['As needed','As needed']]
	GENDER = [['Female', 'Female'],['Male', 'Male'],['Non-binary', 'Non-binary'], ['No preference','No preference']]
	EXPERIENCE = [['1-5', '1-5'],['5-10', '5-10'],['15+', '15+']]
	CURR_ROLE = [['Architect', 'Architect'],['Business Analyst', 'Business Analyst'],['Data Analyst', 'Data Analyst'], ['QA/tester','QA/tester'],['Sales', 'Sales'],['UX/UI', 'UX/UI'],['Developer/Engineer', 'Developer/Engineer'],['Marketing', 'Marketing'],['Project Manager', 'Project Manager'], ['Other', 'Other'] ]
	MENTOR_ROLES = [['Nurturer', 'Nurturer'],['Colleague', 'Colleague'],['Sounding board', 'Sounding board'],['Teacher', 'Teacher'],['Motivator', 'Motivator']]

	def get_matches 
		match = Match.new(self) 
		match.get_mentor_ids 
	end 
	
	def get_pending_mentors 
		mentor_ids = []
		Mentorship.pending.for_mentee(self).each do |mentorship|
			mentor_ids += [mentorship.mentor_id]
		end 
		mentor_ids
	end 
	
	def get_accepted_mentors 
		mentor_ids = []
		Mentorship.accepted.for_mentee(self).each do |mentorship|
			mentor_ids += (mentorship.mentor_id)
		end 
		mentor_ids
	end 
	
	def can_request?(mentor)	
		!self.mentorships.include?(mentor)
	end 
	
	def full_name 
		user = User.find(self.user_id)
		user.first_name + " " + user.last_name 
	end
	
	def email 
		email = User.find(self.user_id).email
		if email.nil? 
			return "N/A"
		else 
			return email
		end 
	end 

	def connections
		self.mentorships.to_a.select{|m| m.mentor_id }
	end

end

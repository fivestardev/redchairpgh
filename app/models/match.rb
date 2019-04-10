class Match

    def initialize(mentee) 
        @mentors = match(mentee)
        # @mentors.each do |mentor|
        #     puts mentor[1]
        # end 
    end 
        
    def match(mentee)
    	#all mentor options that pass binary questions
    	filtered = initial_filter(mentee)
    	#create hash table to store mentors and their weighted points
    	mentor_points = Hash.new 
    	#pass through filtered mentors and associate points with mentors that have skills needed
    	#add these mentors to hash table
    	filtered.each do |mentor|
    		if mentor.specialized_skills.include? mentee.skill_3
    			mentor_points[mentor] = 1
    		end
    		if mentor.specialized_skills.include? mentee.skill_2
    			if mentor_points.empty?
    				mentor_points[mentor] = 2
    			else
    				mentor_points[mentor] += 2
    			end
    		end 
    		if mentor.specialized_skills.include? mentee.skill_1
    			if mentor_points.empty?
    				mentor_points[mentor] = 3
    			else
    				mentor_points[mentor] += 3
    			end 
    		end 
    	end
    	#order hash in descending order of number of points per mentor
    	mentor_points.sort_by {|key,value| value}.reverse
    end

    #check all binary questions, and filter mentors down accordingly
    def initial_filter(mentee)
    	mentor_list = Mentor.all
    	#create array to hold filtered down mentors
    	acceptable = []
    	mentor_list.each do |mentor|
    		if (mentee.mentor_gender == 'As needed' || mentee.mentor_gender == mentor.gender)
    			if mentor.mentor_roles.include? mentee.mentor_role
    				if frequency(mentee, mentor) == true
    					acceptable.push(mentor)
    				end 
    			end 
    		end 
    	end 
    	return acceptable
    end
    
    
    #check if mentor and mentee communication frequency are compatible
    def frequency(mentee, mentor)
    	freq_options = ['Biweekly', 'Monthly', 'Bimonthly', 'Quarterly']
    	if (mentee.comm_frequency == 'As needed' || mentor.comm_frequency == 'As needed')
    		return true
    	elsif mentee.comm_frequency == mentor.comm_frequency
    		return true
    	else
    		mentor_freq_num = freq_options.index(mentor.comm_frequency)
    		mentee_freq_num = freq_options.index(mentee.comm_frequency)
    		if mentor_freq_num < mentee_freq_num 
    			return true 
    		end 
    	end 
    end
    
    def get_mentor_ids
        @mentors 
    end 

end


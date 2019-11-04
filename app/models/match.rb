class Match

    def initialize(mentee) 
        @mentors = match(mentee)
    end 

    #check if match is a mentorship - remove
    #get all mentors for a mentee and check if mentor id is in list ids
        
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
    			if mentor_points[mentor] == nil
    				mentor_points[mentor] = 2
    			else
    				mentor_points[mentor] += 2
    			end
    		end 
    		if mentor.specialized_skills.include? mentee.skill_1
    			if mentor_points[mentor] == nil
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
		puts "############### mentor"
		puts mentor_list.inspect
		puts "############### mentee"
		puts mentee.inspect
    	mentor_list.each do |mentor|
    		if (mentee.mentor_gender == 'No preference' || mentee.mentor_gender == mentor.gender)
    			if (mentor.mentor_roles.include? mentee.mentor_role) && !(mentee.connections.include? mentor.id)
                    if (mentor.is_valid && mentee.user_id != mentor.user_id)
    				    if frequency(mentee, mentor) == true
    					   acceptable.push(mentor)
                        end
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


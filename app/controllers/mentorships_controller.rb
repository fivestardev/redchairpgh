class MentorshipsController < ApplicationController
    # before_action :check_login
    before_action :set_mentorship, only: [:show, :edit, :update, :destroy]
    authorize_resource
    
    def index 
        if current_user.role?(:admin)
            @mentorships = Mentorship.all
            @active_mentorships = Mentorship.active.all 
            @removed_mentorships = Mentorship.removed.all
        else 
        #     mentor = Mentor.find(mentorship.mentor_id).first 
        #     mentee = Mentee.find(mentorship.mentee_id).first
        #     user.id == mentor.user_id || user.id == mentee.user_id 
            @mentor = Mentor.for_user(current_user.id).first 
            @mentee = Mentee.for_user(current_user.id).first 
            @active_mentorships = [] 
            @removed_mentorships = []
            #user_mentorships = [] 
            # mentors.each do |mentor|
            #     user_mentorships += Mentorship.for_mentor(mentor.id).all 
            # end 
            if @mentor
                @mentor_mentorships = Mentorship.for_mentor(@mentor.id).all 
                @active_mentorships += @mentor_mentorships.active
                @removed_mentorships += @mentor_mentorships.removed
            #     @requests = @mentor.get_requests
            end 
            
            # mentees.each do |mentee| 
            #     user_mentorships += Mentorship.for_mentee(mentee.id).all 
            # end 
            if @mentee 
                @mentee_mentorships = Mentorship.for_mentee(@mentee.id).all 
                @active_mentorships += @mentee_mentorships.active
                @removed_mentorships += @mentee_mentorships.removed
            #     @matches = @mentee.get_matches
            end 
        end 
    end 
    
    def create 
        mentee = Mentee.find(params[:mentee_id])
        @mentorship = Mentorship.new(mentor_id: params[:mentor_id], 
                                     mentee_id: params[:mentee_id],
                                     status: 'pending') 
        if @mentorship.save 
            flash[:notice] = 'Request sent!' 
            redirect_to root_path 
        else 
            flash[:notice] = 'Unable to send request.' 
            redirect_to mentee_matches_path(mentee)
        end
    end
    
    def destroy 
        @mentorship = Mentorship.find(params[:id]) 
        @mentorship.destroy 
        flash[:notice] = 'Successfully deleted relationship' 
        redirect_to root_path
    end 
    
    def edit 
    end 
    
    def update 
        mentor = @mentorship.find_mentor 
        mentee = @mentorship.find_mentee 
        
        if @mentorship.status == 'pending'
            @mentorship.update_attributes(:status => 'active')
			MentorshipMailer.with(mentor: mentor, mentee: mentee).acceptance_email_to_mentee.deliver!
			MentorshipMailer.with(mentor: mentor, mentee: mentee).acceptance_email_to_mentor.deliver!
            flash[:notice] = 'Mentorship approved!' 
        elsif @mentorship.status == 'active'
            @mentorship.update_attributes(:status => 'removed')
            flash[:notice] = 'Mentorship removed.' 
        end 
        
        redirect_to mentorships_path
    end 
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_mentorship
      @mentorship = Mentorship.find(params[:id])
    end
    def mentorship_params
      params.require(:mentorship).permit(:mentor_id, :mentee_id, :status)
    end
    
    
end

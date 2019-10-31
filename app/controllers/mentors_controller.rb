class MentorsController < ApplicationController
    # before_action :check_login
    before_action :set_mentor, only: [:show, :edit, :update, :destroy, :requests, :pause, :update_pause]
    authorize_resource
    
    def index
      @mentors = Mentor.all
    end

    def new
        @mentor = Mentor.new
    end
    
    def edit
    end 
    
    def requests 
    end 
    
    def pause
    end 
    
    def update_pause 
      if @mentor.paused 
        @mentor.update_attributes(:paused => false) 
      else 
        @mentor.update_attributes(:paused => true) 
      end 
      redirect_to mentor_requests_path(@mentor)
    end 
  
    def update
        respond_to do |format|
        	if @mentor.update(mentor_params)
				format.html { redirect_to @mentor, notice: 'Mentor was successfully updated.' }
				format.json { render :show, status: :ok, location: @mentor }
        	else
				format.html { render :edit, notice: 'Mentor cannot be updated.' }
				format.json { render json: @mentor.errors, status: :unprocessable_entity }
        	end
        end
    end 
    
    def create
        @mentor = Mentor.new(mentor_params)
        if @mentor.save
          flash[:notice] = "Successfully created mentor profile."
          redirect_to @mentor
        else
            render action: 'new'
        end
    end
    
    def show
    end 
    
    def destroy
        @mentor = Mentor.find(params[:id])
        @mentor.destroy
        flash[:notice] = "Successfully deleted mentor profile."
        redirect_to home_path
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_mentor
      @mentor = Mentor.find(params[:id])
    end
    def mentor_params
		params['mentor']['specialized_skills'] = params['mentor']['hackimpact'];
		params['mentor']['mentor_roles'] = params['mentor']['hackrole'];
		params['mentor']['current_role'] = params['mentor']['hackbackground'];
      params.require(:mentor).permit(:user_id, :is_active, :years_in_field, :years_in_lead, :gender, :comm_frequency, 
                                     :bio, :motivation, :current_role => [],
									 :specialized_skills => [], :mentor_roles => [])
    end
    
end

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :change_password, :destroy, :profile, :setup, :deactivate]
  authorize_resource
  
  def index
    # get all visits in reverse chronological order, 10 per page
    @users = User.alphabetical#.paginate(page: params[:page]).per_page(10)
    if current_user.role != "admin" 
      redirect_to home_path
    end 
  end
  
  def show
    # @user = @user
    @mentor = Mentor.for_user(current_user.id).first
    @mentee = Mentee.for_user(current_user.id).first
  end
  
  def new
    #@user = User.new
  end
  
  def profile 
    if !current_user.new_user?
      redirect_to home_path
    end
  end
  
  def setup
    @user.update_attributes(:active => true)
  end 
  
  def deactivate 
    if current_user.role != "admin"
      redirect_to home_path
    end 
  end 

  def create
    puts "user params down there"
    puts user_params
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Welcome, #{@user.first_name}."
      redirect_to @user
    else
      render action: 'new'
    end
  end
  
  def edit
  end
  
  def update
    puts params 
    puts "SETUP ACCOUNT DETAILS^^"
    if @user.id != current_user.id
      if @user.active 
        @user.update_attributes(:active => false)
      else
        @user.update_attributes(:active => true)
      end 
      redirect_to users_path
    else
      if user_params[:password]
        @user.update(user_params)
        if @user.save 
          redirect_to home_path, notice: "Username and password successfully saved."
        else
          render action: 'change_password'
        end
      else
        if @user.update_attributes(user_params)
          if @user.new_user? 
            puts "NEW USER!!!!!!!"
            @user.update_attributes(:code_of_conduct => true) 
            @user.update_attributes(:is_new => false) 
            if @user.active.nil? || !@user.active
              redirect_to setup_account_path(@user) 
            else 
              redirect_to home_path 
            end 
          else 
            flash[:notice] = "Successfully updated your account."
            redirect_to @user
          end 
        else
          render action: 'edit'
        end
      end 
    end
  end

  def change_password
  end
  
  def destroy
    @user.destroy
    flash[:notice] = "Successfully deleted your account."
    redirect_to root_path
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:uid, :provider, :role, :first_name, :last_name, :image_url, :email, :linkedin_url, :code_of_conduct, :city, :state, :zip, :active, :is_new, :username, :agreed, :password, :password_confirmation, :created_at, :updated_at)
    end
end

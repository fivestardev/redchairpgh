class SessionsController < ApplicationController
  
  def create
    begin
      if params[:commit]
        @user = User.find_by_username(params[:username])
        if @user.nil? || !User.authenticate(params[:username], params[:password])
          flash.now.alert = "Username or password is invalid"
          render 'new'
          return
        else 
          session[:user_id] = @user.id
        end
      else
        auth_hash = request.env['omniauth.auth']
        @user = User.from_omniauth(auth_hash)
        if @user.nil? 
          if User.all.empty?
            @user = User.new(uid: auth_hash['uid'], provider: auth_hash['provider'], 
            role: 'admin', first_name: auth_hash['info']['first_name'], 
            last_name: auth_hash['info']['last_name'], image_url: auth_hash['info']['picture_url'],
            code_of_conduct: false, active: false, is_new: true )
            @user.save
          else
            @user = User.new(uid: auth_hash['uid'], provider: auth_hash['provider'], 
            role: 'contributor', first_name: auth_hash['info']['first_name'], 
            last_name: auth_hash['info']['last_name'], image_url: auth_hash['info']['picture_url'],
            code_of_conduct: false, active: false, is_new: true)
            @user.save 
          end
        end
        session[:user_id] = @user.id
        flash[:success] = "Welcome, #{@user.first_name}!"
      end
    rescue
      flash[:warning] = 'There was an error while trying to authenticate you...'
      render 'new'
    end
    redirect_to create_profile_path(@user.id)

  end

  def destroy
    if current_user
      #session.delete(:user_id)
      reset_session
      flash[:success] = 'See you!'
    end
    redirect_to root_path
  end

  def auth_failure
    puts request.env['omniauth.auth'].to_yaml
    redirect_to about_path
  end
end

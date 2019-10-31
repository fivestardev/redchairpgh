class User < ApplicationRecord
  has_secure_password validations: false

  validates_acceptance_of :code_of_conduct, :message => "must be accepted.", :on => :update
  
  scope :alphabetical,       -> { order('last_name, first_name') }
  scope :is_active,          -> { where('active = ?', true) }
  scope :is_inactive,          -> { where('active = ?', false) }
  
  # validates :username, uniqueness: { case_sensitive: false}
  # validates_presence_of :password, on: :create 
  # validates_presence_of :password_confirmation, on: :create 
  validates_confirmation_of :password, message: "does not match"
  validates_length_of :password, minimum: 4, message: "must be at least 4 characters long", allow_blank: true
  
  def name 
    last_name + ", " + first_name
  end 
  
  def role?(authorized_role)
    return false if role.nil? 
    role.downcase.to_sym == authorized_role 
  end 
  
  def self.authenticate(username,password)
    find_by_username(username).try(:authenticate, password)
  end

  def is_mentee?
    return !Mentee.for_user(id).first.nil? 
  end 
  
  def is_mentor?
    return !Mentor.for_user(id).first.nil?
  end 
  
  def new_user? 
    return is_new
  end 
  
  def agreed_value
    if code_of_conduct != true
      errors.add(:code_of_conduct, "must be checked")
    end
  end

  class << self
    def from_omniauth(auth_hash)
      @user = where(uid: auth_hash['uid'], provider: auth_hash['provider']).first 
      @user
    end

    private

    def get_social_location_for(provider, location_hash)
      case provider
        when 'linkedin'
          location_hash['name']
        else
          location_hash
      end
    end

    def get_social_url_for(provider, urls_hash)
      case provider
        when 'linkedin'
          urls_hash['public_profile']
        else
          urls_hash[provider.capitalize]
      end
    end
  end

  def location 
	  loc = [ city, " ", state, " ", zip ].join
	  loc.strip!
	  loc.blank? ? "N/A" : loc
  end


end

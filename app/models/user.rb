class User < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :reviews

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  def password_required?
    super && provider.blank?
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.find_by_email(auth.info.email)

    unless user
      user = User.create_from_provider(
          auth.extra.raw_info.name,
          auth.provider,
          auth.uid,
          auth.info.email)
    end
    user
  end

  def self.find_for_google_oauth2(auth, signed_in_resource=nil)
    user = User.find_by_email(auth.info.email)

    unless user
      user = User.create_from_provider(
          auth.info.name,
          auth.provider,
          auth.uid,
          auth.info.email
      )
    end
    user
  end

  def self.find_by_email(email)
    User.where(:email => email).first
  end

  def self.create_from_provider(name, provider, uid, email)
    # force unique name if name is already taken
    if User.exists?(name: name)
      name += ' ' + ('a'..'z').to_a.shuffle[0..5].join
    end

    User.create(name:name,
                provider:provider,
                uid:uid,
                email:email,
                password:Devise.friendly_token[0,20])
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end

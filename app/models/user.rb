class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  		 :token_authenticatable, 
         #:recoverable, 
         :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :signature
  # attr_accessible :title, :body

  has_many :posts, :dependent => :destroy
end

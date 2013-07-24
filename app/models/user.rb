class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         #:recoverable, 
         :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :signature
  # attr_accessible :title, :body

#when ur ready for associations
  #has_many :posts
end

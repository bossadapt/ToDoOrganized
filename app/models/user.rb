class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :comments
  has_and_belongs_to_many :projects
  belongs_to :owner, class_name: "User"
  has_many :projects
  def full_name
    "#{first_name} #{last_name}"
  end
end

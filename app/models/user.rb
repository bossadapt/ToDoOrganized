class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :comments
  has_and_belongs_to_many :projects
  has_many :owned_projects, class_name: "Project", foreign_key: "owner_id"
  def full_name
    "#{first_name} #{last_name}"
  end
end

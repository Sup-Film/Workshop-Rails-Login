# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  auth_token             :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :text
#  last_name              :text
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_auth_token            (auth_token)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # User ซัพพอร์ต Devise ใช้ DatabaseAuthen และ Registerable และ Recoverable และ Rememberable และ Validatable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable

  # สร้างความสัมพันธ์กับ Blog โดย User จะมี Blog หลายๆ Blog
  has_many :blogs

  # JWT
  before_create :generate_auth_token

  # ฟังก์ชั่นนี้จะ Generate uuid ให้กับ User และเก็บไว้ในฟิลด์ auth_token
  def generate_auth_token
    self.auth_token = SecureRandom.uuid
  end

  # ฟังก์ชั่นนี้จะสร้าง JWT ให้กับ User โดยกำหนดวันหมดอายุของ JWT ให้เป็น 15 วัน
  # ฟังก์ชั่นนี้จะ return ค่าเป็น JWT ที่สร้างขึ้นมา
  def jwt(exp = 15.days.from_now)
    # ใช้ JWT.encode ในการสร้าง JWT โดยใช้ข้อมูล { auth_token: self.auth_token, exp: exp.to_i } และใช้ secret_key_base ในการเข้ารหัส
    JWT.encode({ auth_token: self.auth_token, exp: exp.to_i }, Rails.application.credentials.secret_key_base, "HS256")
  end
  def as_json_with_jwt
    json = {}
    json[:email] = self.email
    json[:first_name] = self.first_name
    json[:last_name] = self.last_name
    json[:auth_jwt] = self.jwt
    json
  end

  # ฟังก์ชั่นสำหรับ Me
  def as_profile_json
    json = {}
    json[:email] = self.email
    json[:first_name] = self.first_name
    json[:last_name] = self.last_name
    json
  end
end

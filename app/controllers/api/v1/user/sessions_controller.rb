class Api::V1::User::SessionsController < Api::V1::User::AppController
  skip_before_action :set_current_user_from_header, only: [ :sign_in ]

  def sign_in
    # ฟังก์ชั่นนี้จะต้องรับ Params { user: { email: , password: }}
    user = User.find_by_email(params[:user][:email])

    # ถ้าไม่พบ user ให้เรียกใช้ method raise GKError และส่ง message ว่า "User not found"
    raise GKError.new("Invalid email or password") if user.blank?

    if user.valid_password?(params[:user][:password])
      render json: { success: true, user: user.as_json_with_jwt }
    else
      raise GKAuthenticationError.new("Invalid email or password")
    end
  end

  def sign_out
    current_user.generate_auth_token
    current_user.save
    render json: { success: true }, status: :ok
  end

  def me
    render json: { success: true, user: current_user.as_profile_json }, status: :ok
  end
end

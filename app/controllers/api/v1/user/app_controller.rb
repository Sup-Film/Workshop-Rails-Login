class Api::V1::User::AppController < Api::AppController
  # กำหนดก่อนที่จะเข้า Method ใดๆ ให้เรียกใช้ Method set_current_user_from_header
  before_action :set_current_user_from_header

  # ฟังก์ชั่นสำหรับ Set ค่าให้กับ @current_user
  def set_current_user_from_header
    # auth_header เป็นการไปดึงค่า Authorization จาก Header ที่ส่งมา
    auth_header = request.headers["auth-token"]

    # jwt เป็นการดึงค่า JWT จาก auth_header โดยใช้ split เพื่อแยกส่วนของ JWT ออกจาก Bearer ที่อยู่ด้านหน้า
    jwt = auth_header.split(" ").last rescue nil

    # result จะเก็บค่าที่ใช้ JWT.decode ในการ Decode JWT โดยใช้ secret_key_base ในการ Decode และใช้ Algorithm เป็น HS256
    result = JWT.decode(jwt, Rails.application.credentials.secret_key_base, true, { algorithm: "HS256" })
    payload = result.first rescue nil
    @current_user = User.find_by_auth_token(payload["auth_token"]) rescue nil
  end

  def current_user(auth = true)
    if auth && @current_user.blank?
      raise GKAuthenticationError.new("Unauthorized")
    else
      # กำหนดให้เป็น Global Variable เพื่อให้ทุก Subclass สามารถเรียกใช้ได้
      @current_user
    end
  end
end

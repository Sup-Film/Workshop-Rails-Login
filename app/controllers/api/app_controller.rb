class Api::AppController < ApplicationController
  # ถ้าเกิด error จากการเรียกใช้งาน GKError ให้เรียกใช้ method handle_400
  rescue_from GKError, with: :handle_400
  rescue_from GKAuthenticationError, with: :handle_401
  rescue_from JWT::VerificationError, with: :handle_401
  rescue_from JWT::ExpiredSignature, with: :handle_401
  rescue_from JWT::DecodeError, with: :handle_401

  def handle_400(e)
    # เป็นการส่ง response กลับไปให้ client ว่าเกิด error และสาเหตุของ error คืออะไร และ return เพื่อไม่ให้ code ที่อยู่ด้านล่างทำงานต่อ
    render json: { success: false, error: e.message }, status: :bad_request and return
  end

  def handle_401(e)
    render json: { success: false, error: e.message }, status: :unauthorized and return
  end
end

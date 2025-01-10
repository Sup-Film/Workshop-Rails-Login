class Api::V1::User::BlogsController < Api::V1::User::AppController
  # Set ID ของ Blog ที่จะใช้ใน Method ต่างๆ
  before_action :set_blog, only: [ :show, :update, :destroy ]

  def index
    blogs = current_user.blogs
    render json: blogs.as_json
  end

  def show
    render json: @blog.as_json
  end

  def create
    blog = Blog.new(params_for_create)  # สร้าง Blog ใหม่
    blog.title = params[:blog][:title]  # กำหนดค่า title จาก params ที่ส่งมา
    blog.body = params[:blog][:body]  # กำหนดค่า body จาก params ที่ส่งมา
    blog.user_id = current_user.id  # กำหนดค่า user_id จาก current_user
    blog.save # บันทึก Blog ลงในฐานข้อมูล
    render json: blog.as_json # แสดงข้อมูล Blog ที่บันทึกลงในฐานข้อมูล
  end

  def update
    @blog.update(params_for_update)
    render json: @blog.as_json
  end

  def destroy
    render json: { success: @blog.destroy }
  end

  # Strong Parameter

  private

  # ถ้าเราไม่เขียน set_blog ใน Method อื่น ๆ ที่มีการใช้ Parameter ID ของ Blog จะต้องเขียน code นี้ในทุก Method
  def set_blog
    @blog = current_user.blogs.find_by_id(params[:id])  # ค้นหา Blog จาก ID ที่ส่งมา
  end

  def params_for_create
    # กำหนดให้ params ที่ส่งมาต้องมี key ชื่อ blog และ blog มี key ชื่อ title และ body
    # เป็นการป้องกันการส่งค่าที่ไม่ได้รับอนุญาตให้ผ่านไป
    params.require(:blog).permit(:title, :body)
  end

  def params_for_update
    # กำหนดให้ params ที่ส่งมาต้องมี key ชื่อ blog และ blog มี key ชื่อ title และ body
    # เป็นการป้องกันการส่งค่าที่ไม่ได้รับอนุญาตให้ผ่านไป
    params.require(:blog).permit(:title, :body)
  end
end

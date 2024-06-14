# stamps_controller.rb
class StampsController < ApplicationController
    before_action :authenticate_user!

    def show
      @user = User.find(params[:id])
      @diaries = @user.diaries.includes(:stamps)
      if permitted_params[:month] && permitted_params[:year]
        @date = Date.new(permitted_params[:year].to_i, permitted_params[:month].to_i)
      else
        @date = Date.today
      end
      @calendar = generate_calendar(@date)
    end

    private

    def permitted_params
      params.permit(:month, :year)
    end

    def generate_calendar(date)
      start_date = date.beginning_of_month.beginning_of_week(:sunday)
      end_date = date.end_of_month.end_of_week(:sunday)
      (start_date..end_date).to_a.each_slice(7).to_a
    end

    def stamp_for_date(user, date)
      # 日付に対するスタンプを取得するロジックをここに追加
      # 例: user.diaries.find_by(date: date).present?
      user.diaries.find_by(date: date).present? ? 'stamp_image_url' : nil
    end
end

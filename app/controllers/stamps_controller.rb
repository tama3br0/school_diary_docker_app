class StampsController < ApplicationController
    before_action :authenticate_user!

    def show
      @user = User.find(params[:id])
      @diaries = @user.diaries.includes(:stamps)
      @date = Date.new(params[:year].to_i, params[:month].to_i, 1) rescue Date.today
      @permitted_params = params.permit(:month, :year)
    end
end

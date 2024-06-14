class StampsController < ApplicationController
    before_action :authenticate_user!

    def show
      @user = User.find(params[:id])
      @diaries = @user.diaries.includes(:stamps)
      @date = Date.today.change(month: permitted_params[:month].to_i, year: permitted_params[:year].to_i) if permitted_params[:month] && permitted_params[:year]
    end

    private

    def permitted_params
      params.permit(:month, :year)
    end
end

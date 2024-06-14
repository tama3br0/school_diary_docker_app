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
    end

    private

    def permitted_params
      params.permit(:month, :year)
    end
end

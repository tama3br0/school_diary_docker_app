class DiariesController < ApplicationController
    before_action :authenticate_user!

    def new
      @diary = Diary.new
      @questions = Question.all
    end

    def create
      # 同じ日の日記がある場合は削除
      current_user.diaries.where(date: diary_params[:date]).destroy_all
      @diary = current_user.diaries.build(diary_params)

      if @diary.save
        params[:answers].each do |question_id, choose_emotion_id|
          @diary.answers.create(question_id: question_id, choose_emotion_id: choose_emotion_id)
        end

        # スタンプを追加
        Stamp.create(user: current_user, diary: @diary)
        redirect_to stamp_path(current_user.id), notice: 'にっきを ていしゅつしました！'
      else
        @questions = Question.all
        render :new
      end
    end

    def choose_diary
        @date = params[:date]&.to_date || Date.today
        # 現在の週の範囲を設定
        start_of_week = @date.beginning_of_week(:monday)
        end_of_week = @date.end_of_week(:sunday)

        # 前週、今週、来週の範囲を設定
        @previous_week_range = (start_of_week - 7.days)..(end_of_week - 7.days)
        @current_week_range = start_of_week..end_of_week
        @next_week_range = (start_of_week + 7.days)..(end_of_week + 7.days)

        # 現在の週の日記を取得
        @diaries = current_user.diaries.where(date: @current_week_range).order(:date)

        Rails.logger.debug "週の開始日: #{start_of_week}, 週の終了日: #{end_of_week}"
        Rails.logger.debug "取得した日記: #{@diaries.map(&:date)}"
    end


    def show
      @diary = current_user.diaries.find(params[:id])
      @questions = @diary.answers.includes(:question, :choose_emotion).map(&:question).uniq
    end

    private

    def diary_params
      params.require(:diary).permit(:date, :image_url)
    end
end

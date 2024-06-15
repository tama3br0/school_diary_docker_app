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

      # すべての質問に対して回答が提供されているかをチェック
      Rails.logger.debug "params[:answers]の中身をチェック: #{params[:answers].inspect}"
      missing_answers = params[:answers].nil? || params[:answers].values.any?(&:blank?)

      if missing_answers
        flash.now[:alert] = 'こたえていない しつもんがあるよ'
        @questions = Question.all
        Rails.logger.debug "答えていない質問があります"
        render :new
      elsif @diary.save
        params[:answers].each do |question_id, choose_emotion_id|
          @diary.answers.create(question_id: question_id, choose_emotion_id: choose_emotion_id)
        end

        Stamp.create(user: current_user, diary: @diary)
        redirect_to stamp_path(current_user.id), notice: 'にっきを ていしゅつしました！'
      else
        flash.now[:alert] = @diary.errors.full_messages.join(', ')
        @questions = Question.all
        Rails.logger.debug "日記の提出に失敗しました: #{@diary.errors.full_messages.join(', ')}"
        render :new
      end
    end

    def choose_diary
      @date = params[:date]&.to_date || Date.today
      start_of_week = @date.beginning_of_week(:monday)
      end_of_week = @date.end_of_week(:sunday)

      @previous_week_range = (start_of_week - 7.days)..(end_of_week - 7.days + 1.day)
      @current_week_range = start_of_week..(end_of_week + 1.day)
      @next_week_range = (start_of_week + 7.days)..(end_of_week + 7.days + 1.day)

    #   Rails.logger.debug "start_of_week: #{start_of_week}, end_of_week: #{end_of_week}"
    #   Rails.logger.debug "@current_week_range: #{@current_week_range}"
    #   Rails.logger.debug "Previous week range: #{@previous_week_range}"
    #   Rails.logger.debug "Next week range: #{@next_week_range}"

      @diaries = current_user.diaries.where(date: @current_week_range).order(:date)

    #   Rails.logger.debug "取得した日記: #{@diaries.map(&:date)}"
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

class DiariesController < ApplicationController
    before_action :authenticate_user!

    def new
      @diary = Diary.new
      @questions = Question.all
    end

    def create
      current_user.diaries.where(date: diary_params[:date]).destroy_all
      @diary = current_user.diaries.build(diary_params)
      @questions = Question.all
      @selected_answers = params[:answers] || {}

      if @selected_answers.empty? || @questions.any? { |q| @selected_answers[q.id.to_s].blank? }
        flash.now[:alert] = 'こたえていない しつもんがあるよ'
        render :new, status: :unprocessable_entity
      else
        if @diary.save
          @selected_answers.each do |question_id, choose_emotion_id|
            @diary.answers.create(question_id: question_id, choose_emotion_id: choose_emotion_id)
          end
          Stamp.create(user: current_user, diary: @diary)
          redirect_to stamp_path(current_user.id), notice: 'にっきを ていしゅつしました！'
        else
          flash.now[:alert] = @diary.errors.full_messages.join(', ')
          render :new, status: :unprocessable_entity
        end
      end
    end

    # 他のアクションは省略

    private

    def diary_params
      params.require(:diary).permit(:date, :image_url, answers: {})
    end
end

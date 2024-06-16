class DiariesController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_teacher, only: [:edit, :update, :new, :create]

    def new
      @diary = Diary.new(date: params[:date], user_id: params[:user_id])
      @questions = Question.all
    end

    def create
      @diary = Diary.new(diary_params.merge(user_id: params[:diary][:user_id]))
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
          Stamp.create(user: @diary.user, diary: @diary)
          redirect_to stamp_path(@diary.user.id), notice: 'にっきを ていしゅつしました！'
        else
          flash.now[:alert] = @diary.errors.full_messages.join(', ')
          render :new, status: :unprocessable_entity
        end
      end
    end

    def edit
      @diary = Diary.find(params[:id])
    end

    def update
      @diary = Diary.find(params[:id])
      if @diary.update(diary_params)
        redirect_to @diary, notice: 'Diary was successfully updated.'
      else
        render :edit
      end
    end

    private

    def authorize_teacher
      redirect_to(root_path, alert: 'You are not authorized to perform this action.') unless current_user.teacher?
    end

    def diary_params
      params.require(:diary).permit(:date, :user_id, :image_url, answers: {})
    end
end

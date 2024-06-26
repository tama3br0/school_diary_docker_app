class DiariesController < ApplicationController
    before_action :authenticate_user!

    def new
      @diary = Diary.new
      @questions = Question.all
      @selected_answers = {}
    end

    def create
                # デバッグログ追加
        Rails.logger.debug "Diary params: #{diary_params.inspect}"
      current_user.diaries.where(date: diary_params[:date]).destroy_all
      @diary = current_user.diaries.build(diary_params) # <= ここをcurrent_userにしているから、ログインしているユーザーのIDになる
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

    def choose_diary
      @date = params[:date]&.to_date || Date.today
      start_of_week = @date.beginning_of_week(:monday)
      end_of_week = start_of_week + 6.days  # 修正：2週間から1週間に変更

      Rails.logger.debug "Start of week: #{start_of_week}"
      Rails.logger.debug "End of week: #{end_of_week}"

      @previous_week_range = (start_of_week - 7.days)..(end_of_week - 7.days)
      @current_week_range = start_of_week..end_of_week
      @next_week_range = (start_of_week + 7.days)..(end_of_week + 7.days)

      Rails.logger.debug "Previous week range: #{@previous_week_range}"
      Rails.logger.debug "Current week range: #{@current_week_range}"
      Rails.logger.debug "Next week range: #{@next_week_range}"

      @diaries = current_user.diaries.where(date: @current_week_range).order(:date)

      Rails.logger.debug "Diaries: #{@diaries.map(&:date)}"
    end

    def class_diary
      @grade_class = GradeClass.find(params[:id])
      @date = params[:date]&.to_date || Date.today
      @previous_date = @date - 1.day
      @next_date = @date + 1.day

      @students = User.where(grade_class: @grade_class).order(:student_num)
      @questions = Question.all
    end

    def student_diary
      @student = User.find(params[:id])
      @date = params[:date]&.to_date || Date.today
      @previous_month = @date - 1.month
      @next_month = @date + 1.month

      @grade = @student.grade_class.grade
      @class_num = @student.grade_class.class_num
      @student_num = @student.student_num

      @diaries = @student.diaries.where("date >= ? AND date <= ?", @date.beginning_of_month, @date.end_of_month).order(:date)
      @questions = Question.all
      @user = @student  # 追加: @user に選択されたユーザー情報をセット
    end

    def show
      @diary = current_user.diaries.find(params[:id])
      @questions = @diary.answers.includes(:question, :choose_emotion).map(&:question).uniq
    end

    private

    def diary_params
      params.require(:diary).permit(:date, :image_url, answers: {})
    end
end

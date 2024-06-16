class DiariesController < ApplicationController
    before_action :authenticate_user!

    def new
      @diary = Diary.new
      @questions = Question.all
      @selected_answers = {}
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

    def create_diary_for_student
      @student = User.find(diary_params[:user_id])
      @diary = @student.diaries.build(diary_params.except(:user_id))  # user_idを除外してdiary_paramsを使用
      @questions = Question.all
      @selected_answers = params[:answers] || {}

      if @selected_answers.empty? || @questions.any? { |q| @selected_answers[q.id.to_s].blank? }
        flash.now[:alert] = 'こたえていない しつもんがあるよ'
        render :new_diary_for_student, status: :unprocessable_entity
      else
        @student.diaries.where(date: diary_params[:date]).destroy_all  # 新しい日記の生成後に既存の日記を削除
        if @diary.save
          @selected_answers.each do |question_id, choose_emotion_id|
            @diary.answers.create(question_id: question_id, choose_emotion_id: choose_emotion_id)
          end
          Stamp.create(user: @student, diary: @diary)
          redirect_to student_diary_path(@student, date: @diary.date), notice: 'にっきを ていしゅつしました！'
        else
          flash.now[:alert] = @diary.errors.full_messages.join(', ')
          render :new_diary_for_student, status: :unprocessable_entity
        end
      end
    end

    def new_diary_for_student
      @student = User.find(params[:id])
      @diary = Diary.new
      @questions = Question.all
      @selected_answers = {}
    end

    def choose_diary
      @date = params[:date]&.to_date || Date.today
      start_of_week = @date.beginning_of_week(:monday)
      end_of_week = @date.end_of_week(:sunday)

      @previous_week_range = (start_of_week - 7.days)..(end_of_week - 7.days + 1.day)
      @current_week_range = start_of_week..(end_of_week + 1.day)
      @next_week_range = (start_of_week + 7.days)..(end_of_week + 7.days + 1.day)

      @diaries = current_user.diaries.where(date: @current_week_range).order(:date)
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
      params.require(:diary).permit(:date, :image_url, :user_id, answers: {})
    end
  end

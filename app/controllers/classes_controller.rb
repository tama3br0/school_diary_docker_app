class ClassesController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_teacher

    def index
      if current_user.grade_class.present?
        @classes = GradeClass.where(school_code: current_user.grade_class.school_code)
      else
        @classes = GradeClass.none
      end
    end

    def show
      @grade_class = GradeClass.find(params[:id])
      @students = User.where(grade_class: @grade_class).order(:student_num)
    end

    private

    def ensure_teacher
      unless current_user.teacher?
        redirect_to authenticated_root_path, alert: 'このページにアクセスする権限がありません。'
      end
    end
  end

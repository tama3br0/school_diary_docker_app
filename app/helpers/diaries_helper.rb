module DiariesHelper
    def display_user_info(user)
        if user.role == 'teacher'
          "#{user.name}せんせい"
        else
          "#{user.grade_class.grade}ねん#{user.grade_class.class_num}くみ #{user.student_num}ばん"
        end
    end
end

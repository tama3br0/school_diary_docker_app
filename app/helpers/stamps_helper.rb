module StampsHelper
    def japanese_day_names
      %w[げつ か すい もく きん ど にち]
    end

    def japanese_month_calendar(options = {}, &block)
      options[:day_names] = japanese_day_names
      month_calendar(options, &block)
    end

    def display_user_info(user)
        if user.role == 'teacher'
            "#{user.name}せんせい"
        else
            "#{user.grade_class.grade}ねん#{user.grade_class.class_num}くみ #{user.student_num}ばん"
        end
    end

    def display_month_year(date)
        "#{date.year}ねん #{date.month}がつ"
    end
end

module StampsHelper
    def japanese_day_names
      %w[げつ か すい もく きん ど にち]
    end

    def japanese_month_calendar(options = {}, &block)
      options[:day_names] = japanese_day_names
      month_calendar(options, &block)
    end

    def display_user_info(user)
      if user.teacher?
        user.name
      else
        "#{user.grade}年#{user.class_num}組 #{user.student_num}番"
      end
    end
end

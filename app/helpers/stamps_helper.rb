module StampsHelper
    def japanese_day_names
      %w[にち げつ か すい もく きん ど]
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

    def day_color_class(wday)
      case wday
      when 0 then 'sunday'
      when 1 then 'monday'
      when 2 then 'tuesday'
      when 3 then 'wednesday'
      when 4 then 'thursday'
      when 5 then 'friday'
      when 6 then 'saturday'
      end
    end

    def stamp_for_date(user, date)
      user.diaries.find_by(date: date).present? ? 'stamp_image_url' : nil
    end
end

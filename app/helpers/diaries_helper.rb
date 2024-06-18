module DiariesHelper
    def display_user_info(user)
        if user.role == 'teacher'
          "#{user.name}せんせい"
        else
          "#{user.grade_class.grade}ねん#{user.grade_class.class_num}くみ #{user.student_num}ばん"
        end
    end

    def generate_diary_text(diary)
        text = ""

        diary.answers.each do |answer|
          case answer.question.text
          when "がっこうは たのしかったですか？"
            text += generate_school_fun_text(answer.choose_emotion.text)
          when "がっこうの べんきょうは よくわかりましたか？"
            text += generate_study_understanding_text(answer.choose_emotion.text)
          when "やすみじかんは たのしく あそべましたか？"
            text += generate_recess_fun_text(answer.choose_emotion.text)
          when "きゅうしょくは たべられましたか？"
            text += generate_lunch_eating_text(answer.choose_emotion.text)
          end
        end

        text
    end

      private

      def generate_school_fun_text(emotion_text)
        case emotion_text
        when "とても たのしかった"
          "きょうの がっこうは、 とても たのしかったです。\n"
        when "たのしかった"
          "きょうの がっこうは たのしかったです。\n"
        when "すこし たのしかった"
          "きょうの がっこうは すこしだけ たのしかったです。\n"
        when "たのしくなかった"
          "きょうの がっこうは あまり たのしくなかったです。\n"
        else
          ""
        end
      end

      def generate_study_understanding_text(emotion_text)
        case emotion_text
        when "とても よくわかった"
          "きょうの べんきょうは、 とても よく わかりました。\n"
        when "よくわかった"
          "きょうの べんきょうは よく わかりました。\n"
        when "すこし わかった"
          "きょうの べんきょうは すこしだけ わかりました。\n"
        when "わからなかった"
          "きょうの べんきょうは あまり わかりませんでした。\n"
        else
          ""
        end
      end

      def generate_recess_fun_text(emotion_text)
        case emotion_text
        when "とても たのしかった"
          "やすみじかんは、 とても たのしく あそべました。\n"
        when "たのしかった"
          "やすみじかんは たのしく あそべました。\n"
        when "すこし たのしかった"
          "やすみじかんは すこしだけ たのしく あそべました。\n"
        when "たのしくなかった"
          "やすみじかんは あまり たのしく あそべませんでした。\n"
        else
          ""
        end
      end

      def generate_lunch_eating_text(emotion_text)
        case emotion_text
        when "ぜんぶたべて、おかわりもした"
          "きゅうしょくは ぜんぶたべて、おかわりも しました。\n"
        when "のこさずに、ぜんぶたべた"
          "きゅうしょくは のこさずに、ぜんぶたべました。\n"
        when "へらしたけれど、ぜんぶたべた"
          "きゅうしょくは へらしたけれど、ぜんぶたべました。\n"
        when "すこし のこしてしまった"
          "きゅうしょくは すこしだけ のこしてしまいました。\n"
        else
          ""
        end
      end
end

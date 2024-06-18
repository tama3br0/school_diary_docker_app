module DiariesHelper
    def display_user_info(user)
        if user.role == 'teacher'
          "#{user.name}せんせい"
        else
          "#{user.grade_class.grade}ねん#{user.grade_class.class_num}くみ #{user.student_num}ばん"
        end
    end

    def generate_diary_text_with_emotions(diary)
        text = ""

        diary.answers.each do |answer|
          case answer.question.text
          when "がっこうは たのしかったですか？"
            text += generate_school_fun_text_with_emotion(answer.choose_emotion.text, answer.choose_emotion.image_url)
          when "がっこうの べんきょうは よくわかりましたか？"
            text += generate_study_understanding_text_with_emotion(answer.choose_emotion.text, answer.choose_emotion.image_url)
          when "やすみじかんは たのしく あそべましたか？"
            text += generate_recess_fun_text_with_emotion(answer.choose_emotion.text, answer.choose_emotion.image_url)
          when "きゅうしょくは たべられましたか？"
            text += generate_lunch_eating_text_with_emotion(answer.choose_emotion.text, answer.choose_emotion.image_url)
          end
        end

        text
    end

      private

      def generate_school_fun_text_with_emotion(emotion_text, image_url)
        case emotion_text
        when "とても たのしかった"
          "きょうの がっこうは、 とても たのしかったです。<img src='#{image_url}' alt='とても たのしかった' /><br>"
        when "たのしかった"
          "きょうの がっこうは たのしかったです。<img src='#{image_url}' alt='たのしかった' /><br>"
        when "すこし たのしかった"
          "きょうの がっこうは すこしだけ たのしかったです。<img src='#{image_url}' alt='すこし たのしかった' /><br>"
        when "たのしくなかった"
          "きょうの がっこうは あまり たのしくなかったです。<img src='#{image_url}' alt='たのしくなかった' /><br>"
        else
          ""
        end
      end

      def generate_study_understanding_text_with_emotion(emotion_text, image_url)
        case emotion_text
        when "とても よくわかった"
          "きょうの べんきょうは、 とても よく わかりました。<img src='#{image_url}' alt='とても よくわかった' /><br>"
        when "よくわかった"
          "きょうの べんきょうは よく わかりました。<img src='#{image_url}' alt='よくわかった' /><br>"
        when "すこし わかった"
          "きょうの べんきょうは すこしだけ わかりました。<img src='#{image_url}' alt='すこし わかった' /><br>"
        when "わからなかった"
          "きょうの べんきょうは あまり わかりませんでした。<img src='#{image_url}' alt='わからなかった' /><br>"
        else
          ""
        end
      end

      def generate_recess_fun_text_with_emotion(emotion_text, image_url)
        case emotion_text
        when "とても たのしかった"
          "やすみじかんは、 とても たのしく あそべました。<img src='#{image_url}' alt='とても たのしかった' /><br>"
        when "たのしかった"
          "やすみじかんは たのしく あそべました。<img src='#{image_url}' alt='たのしかった' /><br>"
        when "すこし たのしかった"
          "やすみじかんは すこしだけ たのしく あそべました。<img src='#{image_url}' alt='すこし たのしかった' /><br>"
        when "たのしくなかった"
          "やすみじかんは あまり たのしく あそべませんでした。<img src='#{image_url}' alt='たのしくなかった' /><br>"
        else
          ""
        end
      end

      def generate_lunch_eating_text_with_emotion(emotion_text, image_url)
        case emotion_text
        when "ぜんぶたべて、おかわりもした"
          "きゅうしょくは ぜんぶたべて、おかわりも しました。<img src='#{image_url}' alt='ぜんぶたべて、おかわりもした' /><br>"
        when "のこさずに、ぜんぶたべた"
          "きゅうしょくは のこさずに、ぜんぶたべました。<img src='#{image_url}' alt='のこさずに、ぜんぶたべた' /><br>"
        when "へらしたけれど、ぜんぶたべた"
          "きゅうしょくは へらしたけれど、ぜんぶたべました。<img src='#{image_url}' alt='へらしたけれど、ぜんぶたべた' /><br>"
        when "すこし のこしてしまった"
          "きゅうしょくは すこしだけ のこしてしまいました。<img src='#{image_url}' alt='すこし のこしてしまった' /><br>"
        else
          ""
        end
      end
end

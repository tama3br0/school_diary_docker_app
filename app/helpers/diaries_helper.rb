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
          text += generate_school_fun_text_with_emotion(answer.choose_emotion.text, answer.choose_emotion.s3_image_url)
        when "がっこうの べんきょうは よくわかりましたか？"
          text += generate_study_understanding_text_with_emotion(answer.choose_emotion.text, answer.choose_emotion.s3_image_url)
        when "やすみじかんは たのしく あそべましたか？"
          text += generate_recess_fun_text_with_emotion(answer.choose_emotion.text, answer.choose_emotion.s3_image_url)
        when "きゅうしょくは たべられましたか？"
          text += generate_lunch_eating_text_with_emotion(answer.choose_emotion.text, answer.choose_emotion.s3_image_url)
        end
      end

      text
    end

    private

    def generate_school_fun_text_with_emotion(emotion_text, image_url)
      case emotion_text
      when "とても たのしかった"
        "きょうの がっこうは、 とても たのしかったです。#{image_tag_for_emotion(image_url, 'とても たのしかった')}<br>"
      when "たのしかった"
        "きょうの がっこうは たのしかったです。#{image_tag_for_emotion(image_url, 'たのしかった')}<br>"
      when "すこしだけ たのしかった"
        "きょうの がっこうは すこしだけ たのしかったです。#{image_tag_for_emotion(image_url, 'すこしだけ たのしかった')}<br>"
      when "たのしくなかった"
        "きょうの がっこうは あまり たのしくなかったです。#{image_tag_for_emotion(image_url, 'たのしくなかった')}<br>"
      else
        ""
      end
    end

    def generate_study_understanding_text_with_emotion(emotion_text, image_url)
      case emotion_text
      when "とても よくわかった"
        "きょうの べんきょうは、 とても よく わかりました。#{image_tag_for_emotion(image_url, 'とても よくわかった')}<br>"
      when "よくわかった"
        "きょうの べんきょうは よく わかりました。#{image_tag_for_emotion(image_url, 'よくわかった')}<br>"
      when "すこしだけ わかった"
        "きょうの べんきょうは すこしだけ わかりました。#{image_tag_for_emotion(image_url, 'すこしだけ わかった')}<br>"
      when "わからなかった"
        "きょうの べんきょうは あまり わかりませんでした。#{image_tag_for_emotion(image_url, 'わからなかった')}<br>"
      else
        ""
      end
    end

    def generate_recess_fun_text_with_emotion(emotion_text, image_url)
      case emotion_text
      when "とても たのしかった"
        "やすみじかんは、 とても たのしく あそべました。#{image_tag_for_emotion(image_url, 'とても たのしかった')}<br>"
      when "たのしかった"
        "やすみじかんは たのしく あそべました。#{image_tag_for_emotion(image_url, 'たのしかった')}<br>"
      when "すこしだけ たのしかった"
        "やすみじかんは すこしだけ たのしく あそべました。#{image_tag_for_emotion(image_url, 'すこしだけ たのしかった')}<br>"
      when "たのしくなかった"
        "やすみじかんは あまり たのしく あそべませんでした。#{image_tag_for_emotion(image_url, 'たのしくなかった')}<br>"
      else
        ""
      end
    end

    def generate_lunch_eating_text_with_emotion(emotion_text, image_url)
      case emotion_text
      when "ぜんぶたべて、おかわりもした"
        "きゅうしょくは ぜんぶたべて、おかわりも しました。#{image_tag_for_emotion(image_url, 'ぜんぶたべて、おかわりもした')}<br>"
      when "のこさずに、ぜんぶたべた"
        "きゅうしょくは のこさずに、ぜんぶたべました。#{image_tag_for_emotion(image_url, 'のこさずに、ぜんぶたべた')}<br>"
      when "へらしたけれど、ぜんぶたべた"
        "きゅうしょくは へらしたけれど、ぜんぶたべました。#{image_tag_for_emotion(image_url, 'へらしたけれど、ぜんぶたべた')}<br>"
      when "すこしだけ のこしてしまった"
        "きゅうしょくは すこしだけ のこしてしまいました。#{image_tag_for_emotion(image_url, 'すこしだけ のこしてしまった')}<br>"
      else
        ""
      end
    end

    def image_tag_for_emotion(image_url, alt_text)
      if image_url.present?
        "<img src='#{image_url}' alt='#{alt_text}' />"
      else
        ""
      end
    end
end

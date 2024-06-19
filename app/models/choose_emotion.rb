class ChooseEmotion < ApplicationRecord
    has_many :question_emotions, dependent: :destroy
    has_many :questions, through: :question_emotions

    # ActiveStorageも残す(これまで投稿した分があるため)
    has_one_attached :image

    validates :image_url, presence: true

    def s3_image_url
      if image.attached?
        "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/#{image.filename}"
      else
        default_image_url
      end
    end

    private

    def default_image_url
      case text
      when "とても たのしかった", "とても よくわかった", "ぜんぶたべて、おかわりもした"
        "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/very_smile.png"
      when "たのしかった", "よくわかった", "のこさずに、ぜんぶたべた"
        "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/smile.png"
      when "すこし たのしかった", "すこし わかった", "へらしたけれど、ぜんぶたべた"
        "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/normal.png"
      when "たのしくなかった", "わからなかった", "すこし のこしてしまった"
        "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/shock.png"
      else
        "がぞうを うまく ひょうじ できませんでした"
      end
    end
end

class ChooseEmotion < ApplicationRecord
    has_many :question_emotions, dependent: :destroy
    has_many :questions, through: :question_emotions

    # ActiveStorageも残す(これまで投稿した分があるため)
    has_one_attached :image

    validates :image_url, presence: true

    def s3_image_url
      "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/#{image.filename}" if image.attached?
    end
end

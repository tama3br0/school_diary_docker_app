class ChooseEmotion < ApplicationRecord
    has_many :question_emotions, dependent: :destroy
    has_many :questions, through: :question_emotions

    # ActiveStorageも残す(これまで投稿した分があるため)
    has_one_attached :image
    # 新しく追加
    validates :image_url, presence: true
end

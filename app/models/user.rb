class User < ApplicationRecord
    belongs_to :grade_class, optional: true
    has_many :diaries, dependent: :destroy
    has_many :stamps

    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable,
           :omniauthable, omniauth_providers: [:google_oauth2]

    # 一時保存時はバリデーションをスキップ
    validates :grade_class_id, presence: true, unless: :skip_validations
    validates :school_code, presence: true, unless: :skip_validations
    validates :role, presence: true, unless: :skip_validations
    validates :name, presence: true, if: -> { role == 'teacher' }, unless: :skip_validations
    validates :grade, presence: true, if: -> { role == 'student' }, unless: :skip_validations
    validates :class_num, presence: true, if: -> { role == 'student' }, unless: :skip_validations
    validates :student_num, presence: true, if: -> { role == 'student' }, unless: :skip_validations
    validate :unique_student_number, if: -> { role == 'student' }, unless: :skip_validations

    attr_accessor :skip_validations

    def self.from_omniauth(auth)
      user = where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20] if user.new_record?
        user.name = auth.info.name
        user.skip_validations = true
        user.additional_info_provided = false if user.new_record?
        user.save!(validate: false)
      end
      user
    end

    enum role: { student: 0, teacher: 1 }

    def teacher?
      role == 'teacher'
    end

    def diary_for_date(date)
      diaries.find_by(date: date)
    end

    private

    def unique_student_number
      if User.exists?(school_code: school_code, grade: grade, class_num: class_num, student_num: student_num)
        errors.add(:student_num, "すでに他の人が登録されています")
      end
    end
end

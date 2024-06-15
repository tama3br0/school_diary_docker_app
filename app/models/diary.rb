class Diary < ApplicationRecord
    belongs_to :user
    has_many :diary_questions
    has_many :questions, through: :diary_questions
    has_many :answers, dependent: :destroy
    has_many :stamps, dependent: :destroy

    validates :date, presence: true
    # 日付の一意性バリデーションを削除
    # validate :all_questions_answered

    def previous_day
      user.diaries.where('date < ?', date).order(date: :desc).first
    end

    def next_day
      user.diaries.where('date > ?', date).order(date: :asc).first
    end

    private

    def all_questions_answered
      questions = Question.all
      answered_question_ids = answers.map(&:question_id)
      unanswered_questions = questions.reject { |q| answered_question_ids.include?(q.id) }

      if unanswered_questions.any?
        errors.add(:base, 'こたえていない しつもんがあるよ')
      end
    end
end

# app/controllers/graphs_controller.rb
class GraphsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_teacher

    def index
      # 必要な処理を行う
    end

    def class_today
      @date = params[:date] || Date.today
      @previous_date = @date - 1.day
      @next_date = @date + 1.day
      @answers = Answer.joins(:diary).where(diaries: { date: @date, user_id: current_user.class_students.pluck(:id) })

      @categories = {
        '学校' => ['とても たのしかった', 'たのしかった', 'すこし たのしかった', 'たのしくなかった'],
        '勉強' => ['とても よくわかった', 'よくわかった', 'すこし わかった', 'わからなかった'],
        '休み時間' => ['とても たのしかった', 'たのしかった', 'すこし たのしかった', 'たのしくなかった'],
        '給食' => ['ぜんぶたべて、おかわりもした', 'のこさずに、ぜんぶたべた', 'へらしたけれど、ぜんぶたべた', 'すこし のこしてしまった']
      }

      @emotion_data = @categories.each_with_object({}) do |(category, emotions), hash|
        hash[category] = emotions.each_with_object({}) do |emotion, e_hash|
          e_hash[emotion] = @answers.joins(:question).where(questions: { text: category }, choose_emotion: { text: emotion }).count
        end
      end
    end

    def student
      @student = User.find(params[:id])
      @start_date = Date.parse(params[:start_date] || 1.month.ago.to_s)
      @end_date = Date.parse(params[:end_date] || Date.today.to_s)
      @answers = Answer.joins(:diary).where(diaries: { user_id: @student.id, date: @start_date..@end_date })

      @categories = %w[学校 勉強 休み時間 給食]
      @daily_scores = (@start_date..@end_date).each_with_object({}) do |date, hash|
        hash[date] = @categories.each_with_object({}) do |category, cat_hash|
          cat_hash[category] = @answers.joins(:question).where(diaries: { date: date }, questions: { text: category }).sum { |answer| answer_score(answer) }
        end
      end
    end

    private

    def authorize_teacher
      redirect_to root_path unless current_user.teacher?
    end

    def answer_score(answer)
      case answer.choose_emotion.text
      when 'とても たのしかった', 'とても よくわかった', 'ぜんぶたべて、おかわりもした'
        4
      when 'たのしかった', 'よくわかった', 'のこさずに、ぜんぶたべた'
        3
      when 'すこし たのしかった', 'すこし わかった', 'へらしたけれど、ぜんぶたべた'
        2
      when 'たのしくなかった', 'わからなかった', 'すこし のこしてしまった'
        1
      else
        0
      end
    end
end

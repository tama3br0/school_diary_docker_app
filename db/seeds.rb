require 'json'
require 'faker'

# インラインジョブキューを有効にする
Rails.application.config.active_job.queue_adapter = :inline

file_path = Rails.root.join('db', 'questions.json')
questions_data = JSON.parse(File.read(file_path))

puts "データを削除中です..."
QuestionEmotion.delete_all
ChooseEmotion.delete_all
Question.delete_all
puts "削除が完了しました"

questions_data.each_with_index do |question_data, q_index|
  puts "質問 #{q_index + 1} / #{questions_data.size} を処理中"
  start_time = Time.now
  question = Question.find_or_create_by!(text: question_data["text"])
  puts "質問の処理時間: #{Time.now - start_time} 秒"

  question_data["emotions"].each_with_index do |emotion_data, e_index|
    puts "質問 #{q_index + 1} の感情 #{e_index + 1} / #{question_data["emotions"].size} を処理中"
    start_time = Time.now
    emotion = ChooseEmotion.find_or_create_by!(text: emotion_data["text"], level: emotion_data["level"])
    puts "感情の処理時間: #{Time.now - start_time} 秒"

    unless QuestionEmotion.exists?(question: question, choose_emotion: emotion)
      QuestionEmotion.create!(question: question, choose_emotion: emotion)
    end

    if emotion.image.attached?
      puts "感情画像は既に添付されています"
    else
      case emotion_data["text"]
      when "とても たのしかった", "とても よくわかった", "ぜんぶたべて、おかわりもした"
        emotion.image.attach(io: File.open(Rails.root.join('app/assets/images/very_smile.png')), filename: 'very_smile.png')
      when "たのしかった", "よくわかった", "のこさずに、ぜんぶたべた"
        emotion.image.attach(io: File.open(Rails.root.join('app/assets/images/smile.png')), filename: 'smile.png')
      when "すこし たのしかった", "すこし わかった", "へらしたけれど、ぜんぶたべた"
        emotion.image.attach(io: File.open(Rails.root.join('app/assets/images/normal.png')), filename: 'normal.png')
      when "たのしくなかった", "わからなかった", "すこし のこしてしまった"
        emotion.image.attach(io: File.open(Rails.root.join('app/assets/images/shock.png')), filename: 'shock.png')
      end
      puts "画像の添付時間: #{Time.now - start_time} 秒"
    end
  end
end

puts "全ての処理が完了しました"

# 元のジョブキューアダプターに戻す
Rails.application.config.active_job.queue_adapter = :async

# # 学校コード、学年、クラス番号の組み合わせを生成
# school_codes = [1, 2]
# grades = [1, 2]
# class_nums = [1, 2, 3]
# student_count = 30

# # 初期データのクリエーション
# school_codes.each do |school_code|
#   grades.each do |grade|
#     class_nums.each do |class_num|
#       # grade_classesテーブルのエントリを作成
#       grade_class = GradeClass.find_or_create_by!(grade: grade, class_num: class_num, school_code: school_code)

#       # 学生の作成
#       student_count.times do |student_num|
#         user = User.create!(
#           email: Faker::Internet.unique.email,
#           uid: SecureRandom.uuid,
#           provider: 'google',
#           role: 0,  # student
#           grade_class: grade_class,
#           student_num: student_num + 1,
#           password: 'password',
#           password_confirmation: 'password',
#           additional_info_provided: true
#         )

#         # 日記の作成
#         diary = Diary.create!(user_id: user.id, date: Date.today)

#         # 質問に対する回答の作成
#         questions_data.each do |question_data|
#           question = Question.find_by(text: question_data["text"])
#           emotion_data = question_data["emotions"].sample
#           emotion = ChooseEmotion.find_by(text: emotion_data["text"], level: emotion_data["level"])

#           Answer.create!(diary_id: diary.id, question_id: question.id, choose_emotion_id: emotion.id)
#         end

#         # スタンプの作成
#         Stamp.create!(user_id: user.id, diary_id: diary.id)
#       end

#       # 教師の作成
#       teacher_names = ["鈴木 太郎", "田中 花子", "佐藤 次郎"]
#       teacher_names.each do |name|
#         User.create!(
#           email: Faker::Internet.unique.email,
#           uid: SecureRandom.uuid,
#           provider: 'google',
#           role: 1,  # teacher
#           grade_class: grade_class,
#           name: name,
#           password: 'password',
#           password_confirmation: 'password',
#           additional_info_provided: true
#         )
#       end
#     end
#   end
# end

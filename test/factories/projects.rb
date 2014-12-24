# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
  	owner
  	sequence(:name) { |i| "プロジェクト名#{i}" }
  	sequence(:place) { |i| "プロジェクト遂行場所#{i}" }
  	sequence(:content) { |i| "プロジェクト内容#{i}" }
  	start_time { rand(1..30).days.from_now }
  	end_time { start_time + rand(1..30).hours }
  end
end

FactoryBot.define do
  factory :sighting do
    date { "2000/11/01" }
    time { "正午" }
    area { "ハチ公前" }
    situation { "走って行った" }
    lat { 35.65876 }
    lng { 139.701069 }
  end
end

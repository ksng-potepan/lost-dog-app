FactoryBot.define do
  factory :amble do
    name           { "Amble" }
    breed          { "柴犬" }
    size           { "小型" }
    gender         { "不明" }
    color          { "茶色" }
    age            { "2歳" }
    features       { "人懐っこい" }
    tag            { true }
    chip           { true }
    date           { "2000/11/01" }
    time           { "13:00" }
    prefecture     { "東京都" }
    municipalities { "渋谷区" }
    area           { "渋谷駅前" }
    situation      { "散歩中に" }
    notification   { "保健所" }
  end
end

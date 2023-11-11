FactoryBot.define do
  factory :amble,class: Amble do
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

  factory :other_amble,class: Amble do
    name           { "amble" }
    breed          { "豆柴" }
    size           { "小型" }
    gender         { "不明" }
    color          { "黒色" }
    age            { "2歳" }
    features       { "甘えん坊" }
    tag            { true }
    chip           { true }
    date           { "2000/11/11" }
    time           { "11:11" }
    prefecture     { "東京都" }
    municipalities { "渋谷区" }
    area           { "ハチ公前" }
    situation      { "散歩中に" }
    notification   { "警察署" }
  end
end

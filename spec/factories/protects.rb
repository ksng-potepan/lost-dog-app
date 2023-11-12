FactoryBot.define do
  factory :protect,class: Protect do
    name           { "Protect" }
    breed          { "チワワ" }
    size           { "小型" }
    gender         { "不明" }
    color          { "白色" }
    age            { "4歳" }
    features       { "かわいい" }
    tag            { true }
    chip           { true }
    date           { "2000/11/01" }
    time           { "13:00" }
    prefecture     { "北海道" }
    municipalities { "札幌市" }
    area           { "札幌駅前" }
    situation      { "散歩中に" }
    notification   { "保健所" }
    transferred    { false }
    location       { nil }
  end

  factory :other_protect,class: Protect do
    name           { "protect" }
    breed          { "プードル" }
    size           { "小型" }
    gender         { "不明" }
    color          { "黒色" }
    age            { "7歳" }
    features       { "甘えん坊" }
    tag            { true }
    chip           { true }
    date           { "2000/11/11" }
    time           { "11:11" }
    prefecture     { "沖縄県" }
    municipalities { "那覇市" }
    area           { "那覇公園" }
    situation      { "散歩中に" }
    notification   { "警察署" }
    transferred    { false }
    location       { nil }
  end

  factory :trandferred_protect,class: Protect do
    name           { "ferred" }
    breed          { "ポメラニアン" }
    size           { "小型" }
    gender         { "不明" }
    color          { "茶色" }
    age            { "1歳" }
    features       { "破天荒" }
    tag            { true }
    chip           { true }
    date           { "2000/11/01" }
    time           { "11:11" }
    prefecture     { "東京都" }
    municipalities { "渋谷区" }
    area           { "ハチ公前" }
    situation      { "散歩中に" }
    notification   { "警察署" }
    transferred    { true }
    location       { "近所の〇〇さん宅" }
  end
end


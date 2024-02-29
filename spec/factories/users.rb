FactoryBot.define do
  factory :user,class: User do
    username              {"test"}
    email                 {"test@gmail.com"}
    password              {"123456"}
    password_confirmation {"123456"}
  end

  factory :other_user,class: User do
    username              {"other"}
    email                 {"other@gmail.com"}
    password              {"654321"}
    password_confirmation {"654321"}
  end

  factory :guest_user,class: User do
    username              {"guest"}
    email                 {"guest@example.com"}
    password              {"111111"}
    password_confirmation {"111111"}
  end
end

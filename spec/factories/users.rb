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
end

FactoryBot.define do
  factory :item do
    name {Faker::Name.name}
    description {Faker::Books::Dune.quote}
    unit_price {Faker::Number.number(digits: 4)}
    merchant
  end
end

FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }
    # after :create do |merchant|
    #   10.times { merchant.items << FactoryBot.create(:item) }
    # end
  end
end

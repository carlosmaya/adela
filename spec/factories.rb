#encoding: utf-8
FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |n| "user#{n}@example.com" }
    f.name 'Rodrigo'
    f.password 'secretpassword'
    f.password_confirmation 'secretpassword'
    f.association :organization, :factory => :organization

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end

    factory :supervisor do
      after(:create) { |user| user.add_role(:supervisor) }
    end
  end

  factory :organization do |f|
    f.title "Hacienda"
  end

  factory :inventory do |f|
    f.csv_file File.new("#{Rails.root}/spec/fixtures/files/inventory.csv")
    f.association :organization, :factory => :organization
  end

  factory :published_inventory, :parent => :inventory do |f|
    f.published true
    f.publish_date DateTime.now
  end

  factory :opening_plan do |f|
    f.vision "Visión institucional de datos abiertos"
    f.name "Conjuntos de datos priorizados"
    f.description "Descripción de los conjuntos"
    f.publish_date Date.today
    f.association :organization, :factory => :organization

    factory :opening_plan_with_officials do
      after(:build) do |opening_plan|
        opening_plan.officials << FactoryGirl.build(:official, opening_plan: opening_plan, kind: :liaison)
        opening_plan.officials << FactoryGirl.build(:official, opening_plan: opening_plan, kind: :admin)
      end
    end
  end

  factory :official do |f|
    f.name "Elton Spencer"
    f.position "Commissioner for Digital Agenda"
    f.email "elton@spencer.com"
    f.kind :liaison
  end
end

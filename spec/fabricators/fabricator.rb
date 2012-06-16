require 'eventifier'

Fabricator(:event, :class_name => Eventifier::Event) do
  user!
  eventable!(:fabricator => :post)
  verb :update
  change_data { { :date => [5.days.ago, 3.days.ago] } }
end

Fabricator(:notification, :class_name => Eventifier::Notification) do
  event!
  user!
end

Fabricator(:post, :class_name => Post) do
  title { "My amazing blog post" }
  body { "A deep and profound analysis of life" }
end

Fabricator(:user, :class_name => User) do
  name { "Billy #{sequence(:name, 1)}" }
  email{ "billy#{sequence(:email, 1)}@email.com" }
end
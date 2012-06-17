require 'active_support/concern'

module Eventifier
  module EventMethods

    extend ActiveSupport::Concern

    included do
      belongs_to :user
      belongs_to :eventable, :polymorphic => true
      has_many :notifications, :class_name => 'Eventifier::Notification'

      validates :user, :presence => true
      validates :eventable, :presence => true
      validates :verb, :presence => true
    end

    module ClassMethods

      def add_notification(*arg)
        observer_instances.each { |observer| observer.add_notification(*arg) }
      end


      def create_event(verb, object, options = { })
        changed_data = object.changes.stringify_keys
        changed_data = changed_data.reject { |attribute, value| options[:except].include?(attribute) } if options[:except]
        changed_data = changed_data.select { |attribute, value| options[:only].include?(attribute) } if options[:only]
        self.create(
          :user => object.user,
          :eventable => object,
          :verb => verb,
          :change_data => changed_data.symbolize_keys
        )
      end

      def find_all_by_eventable object
        where :eventable_id => object.id, :eventable_type => object.class.name
      end
    end
  end

  if defined? ActiveRecord
    class Event < ActiveRecord::Base
      include Eventifier::EventMethods

      serialize :change_data
    end
  elsif defined? Mongoid
    class Event
      include Mongoid::Document
      include Mongoid::Timestamps
      include Eventifier::EventMethods

      field :change_data, :type => Hash
      field :eventable_type, :type => String
      field :verb, :type => Symbol

      index({ user_id: 1})
      index({ eventable_id: 1, eventable_type: 1 })
    end
  end
end
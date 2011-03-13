module ValidatesAll

  class PresenceOfOneOfValidator < AllValidator
    def initialize(options)
      options.reverse_merge! :message => "#{options[:attributes].map {|attr| attr.to_s.humanize }.to_sentence(:two_words_connector => ' or ', :last_word_connector => ', or ')} must be specified"
      super
    end

    def validate_all(record, attributes, values)
      record.errors.add :base, options[:message] if values.all?(&:blank?)
    end
  end

  module HelperMethods
    # Validates that at least one of the specified attributes are not blank (as defined by Object#blank?). 
    # Happens by default on save. Example:
    #
    #   class Person < ActiveRecord::Base
    #     validates_presence_of_one_of :email_address, :login_name
    #   end
    #
    # Configuration options are the same as validates_all.
    def validates_presence_of_one_of(*attr_names)
      validates_with PresenceOfOneOfValidator, _merge_attributes(attr_names)
    end
    alias_method :validates_presence_of_either, :validates_presence_of_one_of
  end
  ActiveModel::Validations::HelperMethods.send :include, HelperMethods

end

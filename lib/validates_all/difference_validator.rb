module ValidatesAll

  class DifferenceValidator < AllValidator
    def initialize(options)
      attrs = options[:attributes] || []
      options.reverse_merge! :message =>
        "#{attrs.first.to_s.humanize} cannot be the same as " +
        "#{attrs[1,attrs.size-1].map {|attr| attr.to_s.humanize }.to_sentence}"
      super
    end

    def validate_all(record, attributes, values)
      unless options[:suppress_on_blanks] && values.all?(&:blank?)
        record.errors.add :base, options[:message] if values.uniq.length != values.length
      end
    end
  end

  module HelperMethods
    # Validates that each of the specified attributes have a different value.
    #
    #   class Person < ActiveRecord::Base
    #     validates_different :best_friend_id, :second_best_friend_id
    #   end
    #
    # # Configuration options are the same as validates_all, plus:
    # * <tt>suppress_on_blanks</tt> - Prevents any error from being triggered if all attributes are blank.
    def validates_different(*attr_names)
      validates_with DifferenceValidator, _merge_attributes(attr_names)
    end
  end
  ActiveModel::Validations::HelperMethods.send :include, HelperMethods

end

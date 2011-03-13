module ValidatesAll

  class AllValidator < ActiveModel::Validator
    def initialize(options, &block)
      raise "attributes cannot be blank" if options[:attributes].blank?
      @block = block
      super
    end

    def validate(record)
      values = options[:attributes].map { |key| record.send(key) }
      validate_all record, options[:attributes], values
    end

    def validate_all(record, attributes, values)
      raise LocalJumpError, "no block given" if @block.nil?
      @block.call record, attributes, values
    end
  end

  module HelperMethods
    # Validates all the attributes against a block.
    #
    #   class Person < ActiveRecord::Base
    #     validates_all :security_answer_1, :security_answer_2 do |record, attrs, values|
    #       message = '#{attrs.to_sentence(:two_words_connector => ' or ', :last_word_connector => ', or ')} must be set'
    #       record.errors.add_to_base(message) if attrs.all?(&:blank?)
    #     end
    #   end
    #
    # Options:
    # * <tt>on</tt> - Specifies when this validation is active (default is :save, other options :create, :update)
    # * <tt>if</tt> - Specifies a method, proc or string to call to determine if the validation should
    # occur (e.g. :if => :allow_validation, or :if => Proc.new { |user| user.signup_step > 2 }).  The
    # method, proc or string should return or evaluate to a true or false value.
    def validates_all(*attr_names, &block)
      validates_with AllValidator, _merge_attributes(attr_names), &block
    end
  end
  ActiveModel::Validations::HelperMethods.send :include, HelperMethods

end

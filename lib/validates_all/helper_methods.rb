module ActiveModel::Validations::HelperMethods
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
    validates_with ValidatesAll::AllValidator, _merge_attributes(attr_names), &block
  end

  # Validates that at least one of the specified attributes are not blank (as defined by Object#blank?). 
  # Happens by default on save. Example:
  #
  #   class Person < ActiveRecord::Base
  #     validates_presence_of_one_of :email_address, :login_name
  #   end
  #
  # Configuration options are the same as validates_all.
  def validates_presence_of_one_of(*attr_names)
    validates_with ValidatesAll::PresenceOfOneOfValidator, _merge_attributes(attr_names)
  end
  alias_method :validates_presence_of_either, :validates_presence_of_one_of

  # Validates that each of the specified attributes have a different value.
  #
  #   class Person < ActiveRecord::Base
  #     validates_different :best_friend_id, :second_best_friend_id
  #   end
  #
  # # Configuration options are the same as validates_all, plus:
  # * <tt>suppress_on_blanks</tt> - Prevents any error from being triggered if all attributes are blank.
  def validates_different(*attr_names)
    validates_with ValidatesAll::DifferenceValidator, _merge_attributes(attr_names)
  end
end

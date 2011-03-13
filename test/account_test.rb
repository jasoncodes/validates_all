require 'test_helper'

class Account < ActiveRecord::Base
  validates_presence_of_either :email_address, :login_name, :if => Proc.new {|user| user.full_name != 'dan'}
  validates_different :primary_account_holder_id, :secondary_account_holder_id, :suppress_on_blanks => true
  validates_all :email_address, :secondary_account_holder_id do |record, attrs, values|
    record.errors.add :base, "cannot have both email address and secondary account holder" if values.compact.size > 1
  end
end

class AccountTest < ActiveSupport::TestCase
  def setup
    @account = Account.new
  end
  
  def test_should_require_email_address_or_login_name_by_default
    @account.valid?
    assert_match(/Email address or Login name must be specified/i, @account.errors[:base].join)
  end
  
  def test_should_not_require_email_address_or_login_name_if_if_condition_evaluates_to_true
    @account.full_name = 'dan'
    @account.valid?
    assert_blank @account.errors[:base]
  end
  
  def test_should_not_have_error_on_base_if_email_address_is_specified
    @account.email_address = 'dan@danhodos.com'
    @account.valid?
    assert_blank @account.errors[:base]
  end
  
  def test_should_not_have_error_on_base_if_login_name_is_specified
    @account.login_name = 'danhodos'
    @account.valid?
    assert_blank @account.errors[:base]
  end
  
  def test_should_have_error_on_base_if_account_holder_ids_are_the_same_and_not_blank
    @account.primary_account_holder_id = 1
    @account.secondary_account_holder_id = 1
    @account.valid?
    
    assert_match(/Primary account holder cannot be the same as Secondary account holder/i, @account.errors[:base].join)
  end
  
  def test_should_not_have_error_on_base_if_account_holder_ids_are_different
    @account.primary_account_holder_id = 1
    @account.secondary_account_holder_id = 2
    @account.valid?
    
    assert_no_match(/Primary account holder cannot be the same as Secondary account holder/i, @account.errors[:base].join)
  end
  
  def test_should_not_have_error_on_base_if_account_holder_ids_are_both_blank
    @account.valid?
    assert_no_match(/Primary account holder cannot be the same as Secondary account holder/i, @account.errors[:base].join)
  end
  
  def test_should_have_error_with_both_email_address_and_secondary_account_holder_id
    @account.email_address = 'foo@example.com'
    @account.secondary_account_holder_id = 42
    @account.valid?
    assert_match(/cannot have both email address and secondary account holder/i, @account.errors[:base].join)
  end
end
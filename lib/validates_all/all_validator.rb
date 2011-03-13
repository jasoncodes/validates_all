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
end

module ValidatesAll
  class DifferenceValidator < AllValidator
    def validate_all(record, attributes, values)
      return if options[:suppress_on_blanks] && values.all?(&:blank?)
      return if values.uniq.length == values.length

      message = options[:message] || begin
        attribute_names = options[:attributes].map do |key|
          record.class.human_attribute_name key
        end
        "#{attribute_names.shift} cannot be the same as #{attribute_names.to_sentence}"
      end

      record.errors.add :base, message
    end
  end
end

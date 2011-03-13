module ValidatesAll
  class PresenceOfOneOfValidator < AllValidator
    def validate_all(record, attributes, values)
      return unless values.all?(&:blank?)

      message = options[:message] || begin
        attribute_names = options[:attributes].map do |key|
          record.class.human_attribute_name key
        end
        attribute_names.to_sentence(
          :two_words_connector => ' or ',
          :last_word_connector => ', or '
        ) + ' must be specified'
      end

      record.errors.add :base, message
    end
  end
end

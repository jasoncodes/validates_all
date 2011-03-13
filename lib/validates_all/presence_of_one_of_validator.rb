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
end

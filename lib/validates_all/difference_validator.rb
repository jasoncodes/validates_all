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
end

module Buxfer
  class Report
    def initialize(data)
      @data = data['analysis']
      @tags = [@data['rawData']['item']].flatten.map do |item|
        Buxfer::Tag.new(:name => item['tag'], :amount => item['amount'].to_f)
      end
    end

    def image_url
      @data['imageURL']
    end

    def [](value)
      tags.detect{|tag| tag.name == value }
    end

    def tags
      @tags
    end

    def tag_names
      tags.map(&:name)
    end

    def to_s
      tags.collect{|t| [t.name, t.amount].join(': ') }.join("\n")
    end
  end
end
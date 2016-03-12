require 'rom-mapper'
require_relative 'processors/transproc_with_hook'
require_relative 'processors/enhanced_attributes'


module Fruby
  class Mapper < ROM::Mapper

    def self.call(*args)
      build.call(*args)
    end

    def self.build(header = self.header, processor = :enhancedattributes)
      new(header, processor)
    end

    def computed(&blk)
      Processors::EnhancedAttributes::ComputedAttribute.new blk
    end

  end
end # Fruby

require_relative 'mapper/types'

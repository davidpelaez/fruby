module Fruby
  module Syro
    module MetadataHelpers

      def set_metadata(nmeta)
        metadata.merge! nmeta
      end

      def metadata
        @metadata ||= {}
      end

    end
  end
end

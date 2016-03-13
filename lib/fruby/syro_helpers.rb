require_relative 'syro/request_helpers'
require_relative 'syro/json_helpers'
require_relative 'syro/metadata_helpers'
require_relative 'syro/error_helpers'

module Fruby
  module SyroHelpers
    include Syro::RequestHelpers
    include Syro::JSONHelpers
    include Syro::MetadataHelpers
    include Syro::ErrorHelpers
  end
end

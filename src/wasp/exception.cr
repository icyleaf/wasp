module Wasp
  class Error < Exception
  end

  class NotFoundFileError < Error
  end

  class MissingMetadataError < Error
  end
end

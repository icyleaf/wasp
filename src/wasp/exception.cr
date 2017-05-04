module Wasp
  class Error < Exception
  end

  class NotFoundFileError < Error
  end

  class MissingFrontMatterError < Error
  end
end

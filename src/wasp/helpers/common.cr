module Wasp::Helper
  # def self.permalink_section(section)
  #   return "" if !section || section.empty?

  #   case section
  #   when ":year"
  #     date.year
  #   when ":month"
  #     date.month
  #   when ":day"
  #     date.day
  #   when ":title"
  #     @metadata.title.downcase.gsub(" ", "-")
  #   when ":slug"
  #     @metadata.slug ? @metadata.slug : @metadata.title
  #   when ":section"
  #     permalink_path.join("/")
  #   else
  #     # such as :filename or others
  #     @name.chomp(File.extname(@name))
  #   end
  # end
end

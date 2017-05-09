module Wasp
  class Watcher
    getter rules

    struct WatcherFile
      property path, mtime, status

      def initialize(@path : String, @mtime : Time)
      end
    end

    enum WatchFileStatus
      ADDED
      CHANGED
      DELETED
    end

    @source_path : String
    @rules : Array(String)
    @files : Hash(String, WatcherFile)

    def initialize(source_path : String, @rules = ["config.yml", "contents/**/*.md", "layouts/**/*.html", "static/**/*"])
      @source_path = File.expand_path(source_path)
      @files = collect_files
    end

    def start
      loop do
        watch_changes do |file, status|
          puts "#{file} was #{status}"
        end
        sleep 1
      end
    end

    def watch_changes
      @files.each do |file, watch|
        if File.exists?(file)
          latest_file_mtime = file_mtime(file)
          if latest_file_mtime != watch.mtime
            yield file, WatchFileStatus::CHANGED

            watch.mtime = latest_file_mtime
            @files[file] = watch
          end
        else
          yield file, WatchFileStatus::DELETED
        end
      end

      files = collect_files
      if files.size > @files.size
        new_files = files.keys - @files.keys
        new_files.each do |file|
          yield file, WatchFileStatus::ADDED
        end
      end
      @files = files
    end

    def new_files
      new_files = collect_files
      if new_files.size > @files.size
      end
    end

    private def collect_files
      files = {} of String => WatcherFile
      @rules.each do |path|
        Dir.glob(File.join(@source_path, path)).each do |file|
          files[file] = WatcherFile.new(file, file_mtime(file))
        end
      end

      files
    end

    private def file_mtime(file)
      File.stat(file).mtime
    end
  end
end

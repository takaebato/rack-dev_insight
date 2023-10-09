module Rack
  class Analyzer
    class FileStore
      def initialize
        @dir_path = Rack::Analyzer.config.file_store_dir_path
      end

      def write(result)
        ::File.open(file_path(result.id), 'wb+') do |f|
          f.sync = true
          f.write Marshal.dump(result)
        end
        reap_excess_files
      end

      def read(id)
        return nil unless ::File.exist?(file_path(id))

        Marshal.load(::File.open(file_path(id), 'rb', &:read))
      end

      private

      def file_path(id)
        FileUtils.mkdir_p(@dir_path) unless Dir.exist?(@dir_path)
        Pathname.new(@dir_path).join(id.to_s).to_s
      end

      def reap_excess_files
        files = Dir.glob(::File.join(@dir_path, '*')).sort_by { |f| ::File.mtime(f) }
        files[0..-(Rack::Analyzer.config.file_store_pool_size + 1)].each do |old_file|
          ::File.delete(old_file)
        end
      end
    end
  end
end

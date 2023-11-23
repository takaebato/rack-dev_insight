# frozen_string_literal: true

module Rack
  class DevInsight
    class FileStore
      def initialize
        @dir_path = Rack::DevInsight.config.file_store_dir_path
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

        Marshal.load(::File.binread(file_path(id))) # rubocop:disable Security/MarshalLoad
      end

      private

      def file_path(id)
        FileUtils.mkdir_p(@dir_path)
        Pathname.new(@dir_path).join(id.to_s).to_s
      end

      def reap_excess_files
        files = Dir.glob(::File.join(@dir_path, '*')).sort_by { |f| ::File.mtime(f) }
        files[0..-(Rack::DevInsight.config.file_store_pool_size + 1)].each { |old_file| ::File.delete(old_file) }
      end
    end
  end
end

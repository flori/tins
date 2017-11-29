require 'tempfile'

module Tins
  module TempIO
    def temp_io(content = nil)
      Tempfile.open(__method__.to_s, binmode: true) do |io|
        if content.respond_to?(:call)
          content = content.call
        end
        io.write content
        io.rewind
        yield io
      end
    end
  end
end

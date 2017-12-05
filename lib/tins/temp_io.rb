require 'tempfile'

module Tins
  module TempIO
    def temp_io(content = nil)
      Tempfile.open(__method__.to_s, binmode: true) do |io|
        if content.respond_to?(:call)
          if content.respond_to?(:arity) && content.arity == 1
            content.call(io)
          else
            io.write content.call
          end
        else
          io.write content
        end
        io.rewind
        yield io
      end
    end
  end
end

require 'tmpdir'

module Tins
  module TempIO
    def temp_io(content:, name: __method__)
      name = File.basename(name.to_s)
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          File.open(name, 'w+b') do |io|
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
  end
end

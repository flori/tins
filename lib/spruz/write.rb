module Spruz
  module Write
    # Write to a file atomically
    def write(filename, content = nil, mode = 'w')
      temp = File.new(filename + ".tmp.#$$.#{Time.now.to_f}", mode)
      if content.nil? and block_given?
        yield temp
      elsif !content.nil?
        temp.write content
      else
        raise ArgumentError, "either content or block argument required"
      end
      temp.close
      File.rename temp.path, filename
    ensure
      temp and !temp.closed? and temp.close
      File.file?(temp.path) and File.unlink temp.path
    end
  end
end

require 'sinatra/base'

module Sinatra
  module Decompile
    def decompile(pattern, keys = nil, *)
      pattern, keys = pattern if pattern.respond_to? :to_ary
      keys, str     = keys.dup, pattern.inspect
      return pattern unless str.start_with? '/^' and str.end_with? '$/'
      str = str[2..-3].gsub /\\([\.\+\(\)\/])/, '\1'
      str.gsub /\([^\(]*\)/ do |part|
        case part
        when '(.*?)'
          return pattern if keys.shift != 'splat'
          '*'
        when '([^/?#]+)'
          return pattern if keys.empty?
          ":" << keys.shift
        else
          return pattern
        end
      end
    end
  end

  register Decompile
end

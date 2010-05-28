module StackExchange
  module StackOverflow
    class Base 

      class << self
        def parse_with_class(hash, name, klass)
          case hash[name]
            when Hash 
              hash[name] = klass.new(hash[name])
            when Array
              hash[name] = hash[name].map { |value| klass.new(value) }
          end
        end

        def request(path_pattern, id, options)
          options.merge! :id => id
          parse client.request(path_pattern, options)
        end
      end
    end
  end
end
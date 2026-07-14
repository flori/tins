# Tins - Useful tools library in Ruby

## Description

A collection of useful Ruby utilities that extend the standard library with
practical conveniences. Tins provides lightweight, dependency-free tools for
common programming tasks.

## Documentation

Complete API documentation is available at: [GitHub.io](https://flori.github.io/tins/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tins'
```

Or:

```ruby
gem 'tins', require 'tins/xt'
```

to automatically extend some core classes with useful methods.

And then execute:

 $ bundle install

Or install it yourself as:

 $ gem install tins

## Usage

```ruby
# Load all utilities

require 'tins'

# Load all utilities and extends core classes with useful methods
require 'tins/xt'
```
## Some Usage Examples

### Duration Handling

```ruby
require 'tins/duration'

duration = Tins::Duration.new(9000)
puts duration.to_s # "02:30:00"
puts duration.to_i # 9000 (seconds)

# Parse durations from strings
Tins::Duration.parse('2h 30m', template: '%hh %mm') # 9000 (seconds)
```

### Unit Conversion

```ruby
require 'tins/unit'

bytes = Tins::Unit.parse('1.5 GB', unit: ?B).to_i # => 1610612736
puts Tins::Unit.format(bytes, unit: 'B') # "1.500000 GB"
```

### Secure File Writing

```ruby
require 'tins/xt/secure_write'

# Write files safely (atomic operation)
File.secure_write('config.json', '{"key": "value"}')
```

### Time Freezing for Testing

```ruby
require 'tins/xt/time_freezer'

# Freeze time during testing
Tins::TimeFreezer.freeze(Time.new('2011-12-13 14:15:16')) do
  puts Time.now # Always returns the frozen time
end
```

### Building blocks for DSLs

```ruby
class Foo
  include Tins::DynamicScope

  def let(bindings = {})
    dynamic_scope do
      bindings.each { |name, value| send("#{name}=", value) }
      yield
    end
  end

  def twice(x)
    2 * x
  end

  def test
    let x: 1, y: twice(1) do
      let z: twice(x) do
        "#{x} * #{y} == #{z} # => #{x * y == twice(x)}"
      end
    end
  end
end

Foo.new.test # "1 * 2 == 2 # => true"
```

### Core Class Extensions (xt)

When you require `tins/xt`, some useful methods are added to core classes:

```ruby
default_options = {
  format: :json,
  timeout: 30,
  retries: 3
}

user_options = { timeout: 60 }
options = user_options | default_options
# => { format: :json, timeout: 60, retries: 3 }

'1.10.3'.version < '1.9.2'.version # => false

add_one         = -> x { x + 1 }
multiply_by_two = -> x { x * 2 }
composed        = multiply_by_two * add_one
composed.(5) # => 12

# For Testing
>> o = Object.new
>> o.puts # => private method, NoMethodError
>> o = o.expose
>> o.puts "hello"
hello
```

### Hash Symbolization

```ruby
require 'tins/xt/hash_symbolize_keys_recursive'

hash = {
  'name' => 'John',
  'age' => 30,
  'address' => {
    'street' => '123 Main St'
  }
}
hash.symbolize_keys_recursive! # Converts all keys to symbols using a stack-safe deep transformation
```

### Deep Hash and Array Transformation

```ruby
require 'tins/xt/deep_transform'

h = { "name" => "john", "details" => { "city" => "berlin", "tags" => ["ruby", "dev"] } }

# Transform keys to symbols and values (if strings) to uppercase
result = h.deep_transform(
  key:   -> k { k.to_sym },
  value: -> v { v.is_a?(String) ? v.upcase : v }
)
# => { name: "JOHN", details: { city: "BERLIN", tags: ["RUBY", "DEV"] } }
```

#### Advanced Usage (Contextual Transformations)

The `value` lambda can accept 1, 2, or 3 arguments depending on the level of context required for each node's transformation:
- `-> v { ... }`: Global transform (node only).
- `-> k, v { ... }`: Contextual transform (key/index and node).
- `-> k, v, c { ... }`: Full structural transform (key/index, node, and parent container).

#### 🧮 Example: Calculating a moving average on a nested array structure

```ruby
require 'tins/xt/deep_transform'

# Root can be an Array as well
a = (1..10).each_slice(5).map(&:to_a) 
# => [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]]

result = a.deep_transform(value: -> i, x, c { 
  Array === c && Numeric === x && i > 0 ? (c[i-1] + x) / 2.0 : x 
})
# => [[1, 1.5, 2.5, 3.5, 4.5], [6, 6.5, 7.5, 8.5, 9.5]]
```

#### 🛡️ Example: Structural Pruning & Sanitization

Because `deep_transform` processes nodes bottom-up, you can effectively prune
entire branches of a tree by returning an empty container when a specific
condition (like a "private" flag) is met.

```ruby
require 'tins/xt/deep_transform'

# A nested data structure with some sections marked for pruning
api_response = {
  user: { 
    name: "Florian", 
    profile: { bio: "Ruby Expert", internal_id: "SECRET_123", noindex: true } 
  },
  settings: { 
    theme: "dark", 
    debug_info: { logs: ["Error 404"], noindex: true } 
  }
}

# Prune any Hash that is marked with `noindex: true`
sanitized = api_response.deep_transform(value: -> v { 
  (v.is_a?(Hash) && v[:noindex]) ? {} : v 
})

# => { user: { name: "Florian", profile: {} }, settings: { theme: "dark", debug_info: {} } }
```

## Author

[Florian Frank](mailto:flori@ping.de)

## License

[MIT License](./LICENSE)

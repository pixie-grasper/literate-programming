# Literate Programming for Ruby and Markdown!

Let us Literate Programming!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'literate-programming'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install literate-programming

## Usage

- How to Use?

```bash
$ rtangle example.wrb # to get example.rb
$ rweave example.wrb # to get example.md
```

## Examples
- Hello, world!

```:hello.wrb
First, define the Hello, world!
[[hello-world]] =
  "Hello, world!"

Next, define Main Program; 'Hello, world!'
[[*]] =
def main
  p [[hello-world]]
end

Finaly, call the main.
[[*]] +=
main
```

```rb:hello.rb
def main
  p "Hello, world!"
end

main
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


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

### Installation from repository

You are also able to install this gem from github repository.
```bash
$ git clone https://github.com/pixie-grasper/literate-programming.git
$ cd literate-programming
$ rake install
```

## Usage

- How to Use?

```bash
$ rtangle example.wrb # to get example.rb
$ rweave example.wrb # to get example.md
```

## Examples
- Hello, world!

First, write hellow.wrb
```
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

Second, tangle it!
```bash
$ rtangle hello.wrb
```

Finally, you will get hello.rb
```ruby
def main
  p "Hello, world!"
end

main
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


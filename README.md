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

- 99 Bottles

This gem provides the Template Meta Programming.
For example, below code is an implementation of the 99-bottles.

```
First, define the main function and it sings a song ''99 bottles of beer''.
[[*]] =
  def main
    [[bottles:100]]
  end

General case, sing below
If the label-name end with ':@', the rtangle accepts the codes as a general template.
In the general template code,
- if '@'-mark followed by a number, the rtangle replaces it with an argument.
- if '@@'-mark followed by parents, the rtangle replaces it with return value of the insides.
[[bottles:@]] =
  puts '@0 bottles of beer on the wall, @0 bottles of beer.'
  puts 'Take one down and pass it around, @@(@0 - 1) bottles of beer on the wall.'
  [[bottles:@@(@0 - 1)]]

The template code is also able to specialize.
If the rtangle does not find the specialized one,
it specializes from general template code like above.
When number of bottles == 2
[[bottles:2]] =
  puts '2 bottles of beer on the wall, 2 bottles of beer.'
  puts 'Take one down and pass it around, 1 bottle of beer on the wall.'
  [[bottles:1]]

When number of bottles == 1
[[bottles:1]] =
  puts '1 bottle of beer on the wall, 1 bottle of beer.'
  puts 'Take one down and pass it around, no more bottles of beer on the wall.'
  [[bottles:0]]

When no rest bottles...
[[bottles:0]] =
  puts 'No more bottles of beer on the wall, no more bottles of beer.'
  puts 'Go to the store and buy some more, 99 bottles of beer on the wall.'

Finally, call the main function.
[[*]] +=
  main
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


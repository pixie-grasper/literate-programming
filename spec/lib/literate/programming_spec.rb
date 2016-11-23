require 'spec_helper'
require 'literate/programming'

describe 'literate-programming' do
  it 'empty' do
    inst = Literate::Programming.new
    expect(inst.to_ruby).to eq ""
    expect(inst.to_md).to eq ""
    expect(inst.to_tex).to eq <<-TEX
\\documentclass{report}
\\usepackage{listings}
\\begin{document}
\\lstset{language=Ruby}
\\end{document}
    TEX

    inst = Literate::Programming.new ""
    expect(inst.to_ruby).to eq ""
    expect(inst.to_md).to eq ""
    expect(inst.to_tex).to eq <<-TEX
\\documentclass{report}
\\usepackage{listings}
\\begin{document}
\\lstset{language=Ruby}
\\end{document}
    TEX

    inst = Literate::Programming.new $/
    expect(inst.to_ruby).to eq ""
    expect(inst.to_md).to eq ""
    expect(inst.to_tex).to eq <<-TEX
\\documentclass{report}
\\usepackage{listings}
\\begin{document}
\\lstset{language=Ruby}
\\end{document}
    TEX
  end

  it 'simple case 1' do
    inst = Literate::Programming.new <<-EOW
Simple Case 1.
[[*]] =
  p 'Hello, world!'
    EOW

    expect(inst.to_ruby).to eq <<-EOC
p 'Hello, world!'
    EOC

    expect(inst.to_md).to eq <<-EOM
Simple Case 1.
```ruby:*
p 'Hello, world!'
```
    EOM

    expect(inst.to_tex).to eq <<-EOM
\\documentclass{report}
\\usepackage{listings}
\\begin{document}
\\lstset{language=Ruby}
Simple Case 1.
\\begin{lstlisting}[caption=*]
p 'Hello, world!'
\\end{lstlisting}
\\end{document}
    EOM
  end

  it 'simple case 2' do
    inst = Literate::Programming.new <<-EOM
Simple Case 2.
[[hello-world]] =
  'Hello, world!'

The main program says hello!
[[*]] =
  p [[hello-world]]
    EOM

    expect(inst.to_ruby).to eq <<-EOC
p 'Hello, world!'
    EOC

    expect(inst.to_md).to eq <<-EOM
Simple Case 2.
```ruby:hello-world
'Hello, world!'
```

The main program says hello!
```ruby:*
p [[hello-world]]
```
    EOM

    expect(inst.to_tex).to eq <<-TEX
\\documentclass{report}
\\usepackage{listings}
\\begin{document}
\\lstset{language=Ruby}
Simple Case 2.
\\begin{lstlisting}[caption=hello-world]
'Hello, world!'
\\end{lstlisting}

The main program says hello!
\\begin{lstlisting}[caption=*]
p [[hello-world]]
\\end{lstlisting}
\\end{document}
    TEX
  end

  it 'simple case 3' do
    inst = Literate::Programming.new <<-EOM
Simple Case 3.
[[*]] =
  def main
    [[main-body]]
  end

The main function says hello-world
[[main-body]] =
  p [[hello-world]]

Definition of the hello-world is a 'Hello, world!'
[[hello-world]] =
  'Hello, world!'

Finally, call the main function.
[[*]] +=
  main
    EOM

    expect(inst.to_ruby).to eq <<-EOC
def main
  p 'Hello, world!'
end

main
    EOC

    expect(inst.to_md).to eq <<-EOC
Simple Case 3.
```ruby:*
def main
  [[main-body]]
end
```

The main function says hello-world
```ruby:main-body
p [[hello-world]]
```

Definition of the hello-world is a 'Hello, world!'
```ruby:hello-world
'Hello, world!'
```

Finally, call the main function.
```ruby:* append
main
```
    EOC

    expect(inst.to_tex).to eq <<-TEX
\\documentclass{report}
\\usepackage{listings}
\\begin{document}
\\lstset{language=Ruby}
Simple Case 3.
\\begin{lstlisting}[caption=*]
def main
  [[main-body]]
end
\\end{lstlisting}

The main function says hello-world
\\begin{lstlisting}[caption=main-body]
p [[hello-world]]
\\end{lstlisting}

Definition of the hello-world is a 'Hello, world!'
\\begin{lstlisting}[caption=hello-world]
'Hello, world!'
\\end{lstlisting}

Finally, call the main function.
\\begin{lstlisting}[caption=* append]
main
\\end{lstlisting}
\\end{document}
    TEX
  end

  it 'template case 1' do
    inst = Literate::Programming.new <<-EOM
Template Case 1.
[[*]] =
  def main
    [[main-body]]
  end

Sing a song ''99 bottles of beer''
[[main-body]] =
  [[bottles:100]]

General case, sing below
[[bottles:@]] =
  puts '@0 bottles of beer on the wall, @0 bottles of beer.'
  puts 'Take one down and pass it around, @@(@0 - 1) bottles of beer on the wall.'
  [[bottles:@@(@0 - 1)]]

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
    EOM

    expect(inst.to_ruby).to eq <<-EOC
def main
  puts '100 bottles of beer on the wall, 100 bottles of beer.'
  puts 'Take one down and pass it around, 99 bottles of beer on the wall.'
  puts '99 bottles of beer on the wall, 99 bottles of beer.'
  puts 'Take one down and pass it around, 98 bottles of beer on the wall.'
  puts '98 bottles of beer on the wall, 98 bottles of beer.'
  puts 'Take one down and pass it around, 97 bottles of beer on the wall.'
  puts '97 bottles of beer on the wall, 97 bottles of beer.'
  puts 'Take one down and pass it around, 96 bottles of beer on the wall.'
  puts '96 bottles of beer on the wall, 96 bottles of beer.'
  puts 'Take one down and pass it around, 95 bottles of beer on the wall.'
  puts '95 bottles of beer on the wall, 95 bottles of beer.'
  puts 'Take one down and pass it around, 94 bottles of beer on the wall.'
  puts '94 bottles of beer on the wall, 94 bottles of beer.'
  puts 'Take one down and pass it around, 93 bottles of beer on the wall.'
  puts '93 bottles of beer on the wall, 93 bottles of beer.'
  puts 'Take one down and pass it around, 92 bottles of beer on the wall.'
  puts '92 bottles of beer on the wall, 92 bottles of beer.'
  puts 'Take one down and pass it around, 91 bottles of beer on the wall.'
  puts '91 bottles of beer on the wall, 91 bottles of beer.'
  puts 'Take one down and pass it around, 90 bottles of beer on the wall.'
  puts '90 bottles of beer on the wall, 90 bottles of beer.'
  puts 'Take one down and pass it around, 89 bottles of beer on the wall.'
  puts '89 bottles of beer on the wall, 89 bottles of beer.'
  puts 'Take one down and pass it around, 88 bottles of beer on the wall.'
  puts '88 bottles of beer on the wall, 88 bottles of beer.'
  puts 'Take one down and pass it around, 87 bottles of beer on the wall.'
  puts '87 bottles of beer on the wall, 87 bottles of beer.'
  puts 'Take one down and pass it around, 86 bottles of beer on the wall.'
  puts '86 bottles of beer on the wall, 86 bottles of beer.'
  puts 'Take one down and pass it around, 85 bottles of beer on the wall.'
  puts '85 bottles of beer on the wall, 85 bottles of beer.'
  puts 'Take one down and pass it around, 84 bottles of beer on the wall.'
  puts '84 bottles of beer on the wall, 84 bottles of beer.'
  puts 'Take one down and pass it around, 83 bottles of beer on the wall.'
  puts '83 bottles of beer on the wall, 83 bottles of beer.'
  puts 'Take one down and pass it around, 82 bottles of beer on the wall.'
  puts '82 bottles of beer on the wall, 82 bottles of beer.'
  puts 'Take one down and pass it around, 81 bottles of beer on the wall.'
  puts '81 bottles of beer on the wall, 81 bottles of beer.'
  puts 'Take one down and pass it around, 80 bottles of beer on the wall.'
  puts '80 bottles of beer on the wall, 80 bottles of beer.'
  puts 'Take one down and pass it around, 79 bottles of beer on the wall.'
  puts '79 bottles of beer on the wall, 79 bottles of beer.'
  puts 'Take one down and pass it around, 78 bottles of beer on the wall.'
  puts '78 bottles of beer on the wall, 78 bottles of beer.'
  puts 'Take one down and pass it around, 77 bottles of beer on the wall.'
  puts '77 bottles of beer on the wall, 77 bottles of beer.'
  puts 'Take one down and pass it around, 76 bottles of beer on the wall.'
  puts '76 bottles of beer on the wall, 76 bottles of beer.'
  puts 'Take one down and pass it around, 75 bottles of beer on the wall.'
  puts '75 bottles of beer on the wall, 75 bottles of beer.'
  puts 'Take one down and pass it around, 74 bottles of beer on the wall.'
  puts '74 bottles of beer on the wall, 74 bottles of beer.'
  puts 'Take one down and pass it around, 73 bottles of beer on the wall.'
  puts '73 bottles of beer on the wall, 73 bottles of beer.'
  puts 'Take one down and pass it around, 72 bottles of beer on the wall.'
  puts '72 bottles of beer on the wall, 72 bottles of beer.'
  puts 'Take one down and pass it around, 71 bottles of beer on the wall.'
  puts '71 bottles of beer on the wall, 71 bottles of beer.'
  puts 'Take one down and pass it around, 70 bottles of beer on the wall.'
  puts '70 bottles of beer on the wall, 70 bottles of beer.'
  puts 'Take one down and pass it around, 69 bottles of beer on the wall.'
  puts '69 bottles of beer on the wall, 69 bottles of beer.'
  puts 'Take one down and pass it around, 68 bottles of beer on the wall.'
  puts '68 bottles of beer on the wall, 68 bottles of beer.'
  puts 'Take one down and pass it around, 67 bottles of beer on the wall.'
  puts '67 bottles of beer on the wall, 67 bottles of beer.'
  puts 'Take one down and pass it around, 66 bottles of beer on the wall.'
  puts '66 bottles of beer on the wall, 66 bottles of beer.'
  puts 'Take one down and pass it around, 65 bottles of beer on the wall.'
  puts '65 bottles of beer on the wall, 65 bottles of beer.'
  puts 'Take one down and pass it around, 64 bottles of beer on the wall.'
  puts '64 bottles of beer on the wall, 64 bottles of beer.'
  puts 'Take one down and pass it around, 63 bottles of beer on the wall.'
  puts '63 bottles of beer on the wall, 63 bottles of beer.'
  puts 'Take one down and pass it around, 62 bottles of beer on the wall.'
  puts '62 bottles of beer on the wall, 62 bottles of beer.'
  puts 'Take one down and pass it around, 61 bottles of beer on the wall.'
  puts '61 bottles of beer on the wall, 61 bottles of beer.'
  puts 'Take one down and pass it around, 60 bottles of beer on the wall.'
  puts '60 bottles of beer on the wall, 60 bottles of beer.'
  puts 'Take one down and pass it around, 59 bottles of beer on the wall.'
  puts '59 bottles of beer on the wall, 59 bottles of beer.'
  puts 'Take one down and pass it around, 58 bottles of beer on the wall.'
  puts '58 bottles of beer on the wall, 58 bottles of beer.'
  puts 'Take one down and pass it around, 57 bottles of beer on the wall.'
  puts '57 bottles of beer on the wall, 57 bottles of beer.'
  puts 'Take one down and pass it around, 56 bottles of beer on the wall.'
  puts '56 bottles of beer on the wall, 56 bottles of beer.'
  puts 'Take one down and pass it around, 55 bottles of beer on the wall.'
  puts '55 bottles of beer on the wall, 55 bottles of beer.'
  puts 'Take one down and pass it around, 54 bottles of beer on the wall.'
  puts '54 bottles of beer on the wall, 54 bottles of beer.'
  puts 'Take one down and pass it around, 53 bottles of beer on the wall.'
  puts '53 bottles of beer on the wall, 53 bottles of beer.'
  puts 'Take one down and pass it around, 52 bottles of beer on the wall.'
  puts '52 bottles of beer on the wall, 52 bottles of beer.'
  puts 'Take one down and pass it around, 51 bottles of beer on the wall.'
  puts '51 bottles of beer on the wall, 51 bottles of beer.'
  puts 'Take one down and pass it around, 50 bottles of beer on the wall.'
  puts '50 bottles of beer on the wall, 50 bottles of beer.'
  puts 'Take one down and pass it around, 49 bottles of beer on the wall.'
  puts '49 bottles of beer on the wall, 49 bottles of beer.'
  puts 'Take one down and pass it around, 48 bottles of beer on the wall.'
  puts '48 bottles of beer on the wall, 48 bottles of beer.'
  puts 'Take one down and pass it around, 47 bottles of beer on the wall.'
  puts '47 bottles of beer on the wall, 47 bottles of beer.'
  puts 'Take one down and pass it around, 46 bottles of beer on the wall.'
  puts '46 bottles of beer on the wall, 46 bottles of beer.'
  puts 'Take one down and pass it around, 45 bottles of beer on the wall.'
  puts '45 bottles of beer on the wall, 45 bottles of beer.'
  puts 'Take one down and pass it around, 44 bottles of beer on the wall.'
  puts '44 bottles of beer on the wall, 44 bottles of beer.'
  puts 'Take one down and pass it around, 43 bottles of beer on the wall.'
  puts '43 bottles of beer on the wall, 43 bottles of beer.'
  puts 'Take one down and pass it around, 42 bottles of beer on the wall.'
  puts '42 bottles of beer on the wall, 42 bottles of beer.'
  puts 'Take one down and pass it around, 41 bottles of beer on the wall.'
  puts '41 bottles of beer on the wall, 41 bottles of beer.'
  puts 'Take one down and pass it around, 40 bottles of beer on the wall.'
  puts '40 bottles of beer on the wall, 40 bottles of beer.'
  puts 'Take one down and pass it around, 39 bottles of beer on the wall.'
  puts '39 bottles of beer on the wall, 39 bottles of beer.'
  puts 'Take one down and pass it around, 38 bottles of beer on the wall.'
  puts '38 bottles of beer on the wall, 38 bottles of beer.'
  puts 'Take one down and pass it around, 37 bottles of beer on the wall.'
  puts '37 bottles of beer on the wall, 37 bottles of beer.'
  puts 'Take one down and pass it around, 36 bottles of beer on the wall.'
  puts '36 bottles of beer on the wall, 36 bottles of beer.'
  puts 'Take one down and pass it around, 35 bottles of beer on the wall.'
  puts '35 bottles of beer on the wall, 35 bottles of beer.'
  puts 'Take one down and pass it around, 34 bottles of beer on the wall.'
  puts '34 bottles of beer on the wall, 34 bottles of beer.'
  puts 'Take one down and pass it around, 33 bottles of beer on the wall.'
  puts '33 bottles of beer on the wall, 33 bottles of beer.'
  puts 'Take one down and pass it around, 32 bottles of beer on the wall.'
  puts '32 bottles of beer on the wall, 32 bottles of beer.'
  puts 'Take one down and pass it around, 31 bottles of beer on the wall.'
  puts '31 bottles of beer on the wall, 31 bottles of beer.'
  puts 'Take one down and pass it around, 30 bottles of beer on the wall.'
  puts '30 bottles of beer on the wall, 30 bottles of beer.'
  puts 'Take one down and pass it around, 29 bottles of beer on the wall.'
  puts '29 bottles of beer on the wall, 29 bottles of beer.'
  puts 'Take one down and pass it around, 28 bottles of beer on the wall.'
  puts '28 bottles of beer on the wall, 28 bottles of beer.'
  puts 'Take one down and pass it around, 27 bottles of beer on the wall.'
  puts '27 bottles of beer on the wall, 27 bottles of beer.'
  puts 'Take one down and pass it around, 26 bottles of beer on the wall.'
  puts '26 bottles of beer on the wall, 26 bottles of beer.'
  puts 'Take one down and pass it around, 25 bottles of beer on the wall.'
  puts '25 bottles of beer on the wall, 25 bottles of beer.'
  puts 'Take one down and pass it around, 24 bottles of beer on the wall.'
  puts '24 bottles of beer on the wall, 24 bottles of beer.'
  puts 'Take one down and pass it around, 23 bottles of beer on the wall.'
  puts '23 bottles of beer on the wall, 23 bottles of beer.'
  puts 'Take one down and pass it around, 22 bottles of beer on the wall.'
  puts '22 bottles of beer on the wall, 22 bottles of beer.'
  puts 'Take one down and pass it around, 21 bottles of beer on the wall.'
  puts '21 bottles of beer on the wall, 21 bottles of beer.'
  puts 'Take one down and pass it around, 20 bottles of beer on the wall.'
  puts '20 bottles of beer on the wall, 20 bottles of beer.'
  puts 'Take one down and pass it around, 19 bottles of beer on the wall.'
  puts '19 bottles of beer on the wall, 19 bottles of beer.'
  puts 'Take one down and pass it around, 18 bottles of beer on the wall.'
  puts '18 bottles of beer on the wall, 18 bottles of beer.'
  puts 'Take one down and pass it around, 17 bottles of beer on the wall.'
  puts '17 bottles of beer on the wall, 17 bottles of beer.'
  puts 'Take one down and pass it around, 16 bottles of beer on the wall.'
  puts '16 bottles of beer on the wall, 16 bottles of beer.'
  puts 'Take one down and pass it around, 15 bottles of beer on the wall.'
  puts '15 bottles of beer on the wall, 15 bottles of beer.'
  puts 'Take one down and pass it around, 14 bottles of beer on the wall.'
  puts '14 bottles of beer on the wall, 14 bottles of beer.'
  puts 'Take one down and pass it around, 13 bottles of beer on the wall.'
  puts '13 bottles of beer on the wall, 13 bottles of beer.'
  puts 'Take one down and pass it around, 12 bottles of beer on the wall.'
  puts '12 bottles of beer on the wall, 12 bottles of beer.'
  puts 'Take one down and pass it around, 11 bottles of beer on the wall.'
  puts '11 bottles of beer on the wall, 11 bottles of beer.'
  puts 'Take one down and pass it around, 10 bottles of beer on the wall.'
  puts '10 bottles of beer on the wall, 10 bottles of beer.'
  puts 'Take one down and pass it around, 9 bottles of beer on the wall.'
  puts '9 bottles of beer on the wall, 9 bottles of beer.'
  puts 'Take one down and pass it around, 8 bottles of beer on the wall.'
  puts '8 bottles of beer on the wall, 8 bottles of beer.'
  puts 'Take one down and pass it around, 7 bottles of beer on the wall.'
  puts '7 bottles of beer on the wall, 7 bottles of beer.'
  puts 'Take one down and pass it around, 6 bottles of beer on the wall.'
  puts '6 bottles of beer on the wall, 6 bottles of beer.'
  puts 'Take one down and pass it around, 5 bottles of beer on the wall.'
  puts '5 bottles of beer on the wall, 5 bottles of beer.'
  puts 'Take one down and pass it around, 4 bottles of beer on the wall.'
  puts '4 bottles of beer on the wall, 4 bottles of beer.'
  puts 'Take one down and pass it around, 3 bottles of beer on the wall.'
  puts '3 bottles of beer on the wall, 3 bottles of beer.'
  puts 'Take one down and pass it around, 2 bottles of beer on the wall.'
  puts '2 bottles of beer on the wall, 2 bottles of beer.'
  puts 'Take one down and pass it around, 1 bottle of beer on the wall.'
  puts '1 bottle of beer on the wall, 1 bottle of beer.'
  puts 'Take one down and pass it around, no more bottles of beer on the wall.'
  puts 'No more bottles of beer on the wall, no more bottles of beer.'
  puts 'Go to the store and buy some more, 99 bottles of beer on the wall.'
end

main
    EOC

    expect(inst.to_md).to eq <<-EOC
Template Case 1.
```ruby:*
def main
  [[main-body]]
end
```

Sing a song ''99 bottles of beer''
```ruby:main-body
[[bottles:100]]
```

General case, sing below
```ruby:bottles:@
puts '@0 bottles of beer on the wall, @0 bottles of beer.'
puts 'Take one down and pass it around, @@(@0 - 1) bottles of beer on the wall.'
[[bottles:@@(@0 - 1)]]
```

When number of bottles == 2
```ruby:bottles:2
puts '2 bottles of beer on the wall, 2 bottles of beer.'
puts 'Take one down and pass it around, 1 bottle of beer on the wall.'
[[bottles:1]]
```

When number of bottles == 1
```ruby:bottles:1
puts '1 bottle of beer on the wall, 1 bottle of beer.'
puts 'Take one down and pass it around, no more bottles of beer on the wall.'
[[bottles:0]]
```

When no rest bottles...
```ruby:bottles:0
puts 'No more bottles of beer on the wall, no more bottles of beer.'
puts 'Go to the store and buy some more, 99 bottles of beer on the wall.'
```

Finally, call the main function.
```ruby:* append
main
```
    EOC

    expect(inst.to_tex).to eq <<-TEX
\\documentclass{report}
\\usepackage{listings}
\\begin{document}
\\lstset{language=Ruby}
Template Case 1.
\\begin{lstlisting}[caption=*]
def main
  [[main-body]]
end
\\end{lstlisting}

Sing a song ''99 bottles of beer''
\\begin{lstlisting}[caption=main-body]
[[bottles:100]]
\\end{lstlisting}

General case, sing below
\\begin{lstlisting}[caption=bottles:@]
puts '@0 bottles of beer on the wall, @0 bottles of beer.'
puts 'Take one down and pass it around, @@(@0 - 1) bottles of beer on the wall.'
[[bottles:@@(@0 - 1)]]
\\end{lstlisting}

When number of bottles == 2
\\begin{lstlisting}[caption=bottles:2]
puts '2 bottles of beer on the wall, 2 bottles of beer.'
puts 'Take one down and pass it around, 1 bottle of beer on the wall.'
[[bottles:1]]
\\end{lstlisting}

When number of bottles == 1
\\begin{lstlisting}[caption=bottles:1]
puts '1 bottle of beer on the wall, 1 bottle of beer.'
puts 'Take one down and pass it around, no more bottles of beer on the wall.'
[[bottles:0]]
\\end{lstlisting}

When no rest bottles...
\\begin{lstlisting}[caption=bottles:0]
puts 'No more bottles of beer on the wall, no more bottles of beer.'
puts 'Go to the store and buy some more, 99 bottles of beer on the wall.'
\\end{lstlisting}

Finally, call the main function.
\\begin{lstlisting}[caption=* append]
main
\\end{lstlisting}
\\end{document}
    TEX
  end

  it 'template case 2' do
    inst = Literate::Programming.new <<-EOM
Template Case 2.
[[*]] =
  class Main
    [[main-body]]
  end

It is free to use @ unless it is followed by a number.
It is also free to use @@ unless it is followed by left parent.
[[main-body]] =
  def initialize
    @x = @@default_x
  end

If @@ is followed by left parent, it will evaluated by the rtangle.
For example, an rtangled below one will equals to '@@default_x = 10'
[[main-body]] +=
  @@default_x = @@(1 + 2 + 3 + 4)

How Main.new.run works?
[[main-body]] +=
  def run
    p 'Hello!'
  end

Finally, instanciate Main and run it!
[[*]] +=
  Main.new.run
    EOM

    expect(inst.to_ruby).to eq <<-EOC
class Main
  def initialize
    @x = @@default_x
  end

  @@default_x = 10

  def run
    p 'Hello!'
  end
end

Main.new.run
    EOC

    expect(inst.to_md).to eq <<-EOC
Template Case 2.
```ruby:*
class Main
  [[main-body]]
end
```

It is free to use @ unless it is followed by a number.
It is also free to use @@ unless it is followed by left parent.
```ruby:main-body
def initialize
  @x = @@default_x
end
```

If @@ is followed by left parent, it will evaluated by the rtangle.
For example, an rtangled below one will equals to '@@default_x = 10'
```ruby:main-body append
@@default_x = @@(1 + 2 + 3 + 4)
```

How Main.new.run works?
```ruby:main-body append
def run
  p 'Hello!'
end
```

Finally, instanciate Main and run it!
```ruby:* append
Main.new.run
```
    EOC

    expect(inst.to_tex).to eq <<-TEX
\\documentclass{report}
\\usepackage{listings}
\\begin{document}
\\lstset{language=Ruby}
Template Case 2.
\\begin{lstlisting}[caption=*]
class Main
  [[main-body]]
end
\\end{lstlisting}

It is free to use @ unless it is followed by a number.
It is also free to use @@ unless it is followed by left parent.
\\begin{lstlisting}[caption=main-body]
def initialize
  @x = @@default_x
end
\\end{lstlisting}

If @@ is followed by left parent, it will evaluated by the rtangle.
For example, an rtangled below one will equals to '@@default_x = 10'
\\begin{lstlisting}[caption=main-body append]
@@default_x = @@(1 + 2 + 3 + 4)
\\end{lstlisting}

How Main.new.run works?
\\begin{lstlisting}[caption=main-body append]
def run
  p 'Hello!'
end
\\end{lstlisting}

Finally, instanciate Main and run it!
\\begin{lstlisting}[caption=* append]
Main.new.run
\\end{lstlisting}
\\end{document}
    TEX
  end

  it '*before* label' do
    inst = Literate::Programming.new <<-EOM
If you want to do something that requires many sentence,
you can use *before* label;
It will be expanded and be evaluated by rtangle to help to write.
[[*]] =
  def main
    @@(helper_function)
  end

For example, *before* label likes below;
Note: the *before*before* label, the *before*before*before* label, and so on, are also exists.
[[*before*]] =
  def helper_function
    return "p 'Hello, world!'"
  end

Finally, call the main function.
[[*]] +=
  main
    EOM

    expect(inst.to_ruby).to eq <<-EOC
def main
  p 'Hello, world!'
end

main
    EOC

    expect(inst.to_md).to eq <<-EOC
If you want to do something that requires many sentence,
you can use *before* label;
It will be expanded and be evaluated by rtangle to help to write.
```ruby:*
def main
  @@(helper_function)
end
```

For example, *before* label likes below;
Note: the *before*before* label, the *before*before*before* label, and so on, are also exists.
```ruby:*before*
def helper_function
  return "p 'Hello, world!'"
end
```

Finally, call the main function.
```ruby:* append
main
```
    EOC

    expect(inst.to_tex).to eq <<-TEX
\\documentclass{report}
\\usepackage{listings}
\\begin{document}
\\lstset{language=Ruby}
If you want to do something that requires many sentence,
you can use *before* label;
It will be expanded and be evaluated by rtangle to help to write.
\\begin{lstlisting}[caption=*]
def main
  @@(helper_function)
end
\\end{lstlisting}

For example, *before* label likes below;
Note: the *before*before* label, the *before*before*before* label, and so on, are also exists.
\\begin{lstlisting}[caption=*before*]
def helper_function
  return "p 'Hello, world!'"
end
\\end{lstlisting}

Finally, call the main function.
\\begin{lstlisting}[caption=* append]
main
\\end{lstlisting}
\\end{document}
    TEX
  end
end

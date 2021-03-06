require "literate/programming/version"

module Literate
  class Programming
    attr_writer :tabstop, :expandtab

    def initialize(src = "", source: nil, tabstop: 2, expandtab: true)
      @source = source || src
      @tabstop = tabstop
      @expandtab = expandtab
      @eval_context = BasicObject.new
      @eval_context.instance_eval <<-EOC
        def gensym
          return (0 .. 20).collect { ('a' .. 'z').to_a[::Random.rand(26)] }.join
        end
      EOC
    end

    def inspect
      return "#<Literate::Programming:0x#{object_id.to_s(16)} tabstop=#{@tabstop} expandtab=#{@expandtab}>"
    end

    def <<(append)
      @source << append
    end

    def to_ruby
      convert[:rb]
    end

    def to_md
      convert[:md]
    end

    def to_tex
      convert[:tex]
    end

   private
    def convert
      current_mode = :text
      md = ""
      tex = <<-TEX
\\documentclass{report}
\\usepackage{listings}
\\begin{document}
\\lstset{language=Ruby}
      TEX
      table = {}
      current_code = nil
      current_label = nil
      operator = nil
      @source.split($/).each do |line|
        old_mode = current_mode
        case current_mode
        when :text
          if line.match /^[ \t]*\[\[([^\]]+)\]\][ \t]*(\+?=|<<)[ \t]*$/ then
            current_mode = :code
            current_code = ''
            current_label = $1
            case $2
              when '='
                operator = :assign
              when '+=', '<<'
                operator = :append
            end
          end
        when :code
          if line.match /^[ \t]*$/ then
            current_mode = :text
          else
            line = line.match(/^[ \t]*/).post_match
          end
        end
        case current_mode
        when :text
          if old_mode == :code then
            case operator
              when :assign
                raise if table[current_label]
                table[current_label] = current_code
              when :append
                table[current_label] ||= ''
                table[current_label] << $/ << current_code
            end
            md << '```' << $/ << $/
            tex << '\\end{lstlisting}' << $/ << $/
          else
            md << line << $/
            tex << line << $/
          end
        when :code
          if old_mode == :code then
            current_code << line << $/
            md << line << $/
            tex << line << $/
          else
            md << '```ruby:' << current_label
            md << ' append' if operator == :append
            md << $/
            tex << '\\begin{lstlisting}[frame=lines,caption=' << current_label
            tex << ' append' if operator == :append
            tex << ']' << $/
          end
        end
      end
      if current_mode == :code then
        case operator
        when :assign
          table[current_label] = current_code
        when :append
          table[current_label] ||= ''
          table[current_label] << $/ << current_code
        end
        md << '```' << $/
        tex << '\\end{lstlisting}' << $/
      end
      table['*'] ||= ''
      tex << <<-TEX
\\end{document}
      TEX
      return {rb: indent_code(expand(table, '*')), md: indent_markdown(md), tex: indent_tex(tex)}
    end

    def expand(table, label)
      @eval_context.instance_eval(expand(table, label + 'before*')) if table.member? label + 'before*'
      processed = ''
      processing = "[[#{label}]]"
      while processing.match /^((?:[^\[]|\[[^\[])*)\[\[([^\]]+)\]\]/m
        processed << $1
        expanding = $2
        follow = $~.post_match
        if table.member? expanding then
          processing = expand_template(table[expanding], nil).chomp
        elsif expanding.match /^([^:]+):([^,]+)(,[^,]+)*$/ then
          true_expanding = $1 + ':@'
          args = $~.to_a[2..-2]
          raise 'undefined ' + expanding unless table.member? true_expanding
          processing = expand_template(table[true_expanding], args).chomp
        else
          raise 'undefined ' + expanding
        end
        processing << follow
      end
      return processed << processing
    end

    def expand_template(string, args)
      processed = ''
      processing = string
      while processing.match /^((?:[^@]|@[^0-9@])*)@/m
        processed << $1
        follow = $~.post_match
        if follow.match /^(0|[1-9][0-9]*)/m then
          # @num -> args[num]
          processed << args[$1.to_i]
          processing = $~.post_match
        elsif follow.match /^@/m then
          follow = $~.post_match
          if follow.match /^(?<paren>\((?:[^()]|\g<paren>)*\))/m then
            # @@(expr) -> eval(expr)
            post_match = $~.post_match
            expanding = @eval_context.instance_eval(expand_template $1, args)
            processed << expanding.to_s
            processing = post_match
          else
            processed << '@@'
            processing = follow
          end
        else
          processed << '@'
          processing = follow
        end
      end
      return processed << processing
    end

    def indent_code(code)
      indent_level_stack = [-1]
      ret = ''
      code.split($/).each do |line|
        ret, indent_level_stack = pretty_print_ruby ret, indent_level_stack, line
      end
      return ret
    end

    def indent_markdown(text)
      mode = :text
      ret = ''
      indent_level_stack = nil
      text.split($/).each do |line|
        if mode == :text and line.match /^```/ then
          mode = :code
          indent_level_stack = [-1]
          ret << line << $/
        elsif mode == :text then
          ret << line << $/
        elsif mode == :code and line.match /^```/ then
          mode = :text
          ret << line << $/
        else
          ret, indent_level_stack = pretty_print_ruby ret, indent_level_stack, line
        end
      end
      return ret
    end

    def indent_tex(text)
      mode = :text
      ret = ''
      indent_level_stack = nil
      text.split($/).each do |line|
        if mode == :text and line.match /^\\begin{lstlisting}/ then
          mode = :code
          indent_level_stack = [-1]
          ret << line << $/
        elsif mode == :text then
          ret << line << $/
        elsif mode == :code and line.match /^\\end{lstlisting}/ then
          mode = :text
          ret << line << $/
        else
          ret, indent_level_stack = pretty_print_ruby ret, indent_level_stack, line
        end
      end
      return ret
    end

    def pretty_print_ruby(buffer, indent_level_stack, line)
      if line.match /^[ \t]*(else|elsif|ensure|rescue|when)\b/ then
        current_indent_level = indent_level_stack[-1]
      elsif line.match /\b(end)\b/ then
        current_indent_level = indent_level_stack.pop
      else
        current_indent_level = indent_level_stack[-1] + 1
      end
      if line.match /^[ \t]*$/ then
        buffer << $/
      elsif @expandtab then
        buffer << ' ' * current_indent_level * @tabstop << line << $/
      else
        buffer << '\t' * current_indent_level << line << $/
      end
      if line.match /^[ \t]*(begin|class|def|for|while|module)\b/
        indent_level_stack.push current_indent_level
      end
      return buffer, indent_level_stack
    end
  end
end

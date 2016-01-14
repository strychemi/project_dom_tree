Tag = Struct.new(:text, :type, :classes, :id, :name, :children, :parent)

class DomParser

  def initialize
    @root = nil # html?
    @depth = 0
  end

  #returns Hash or Struct after parsing HTML
  def parse_tag(input)

    tag = Tag.new

    tag_type_regex = /<[a-z]*[0-9]*/
    class_regex = /class=('|")[[a-z0-9]*\W*\s]*?('|")/
    id_regex = /id=('|")[[a-z0-9]*\W*]*?('|")/
    name_regex = /name=('|")[[a-z0-9]*\W*]*?('|")/
    # text_regex = />(\s*.*?\s*)</

    tag.type = input.match(tag_type_regex).to_s[1..-1]
    tag.classes = input.match(class_regex).to_s[7..-2].split(' ')
    tag.id = input.match(id_regex).to_s[4..-2]
    tag.name = input.match(name_regex).to_s[6..-2]
    return tag
  end

  tag = parse_tag("<h3 id='baz123' class='foo-bar foo bar test-ing' name='fozzie'>bla bla bla</h3>")

  p tag.type
  p tag.classes
  p tag.id
  p tag.name


  # <div>
  #   div text before
  #   <p>
  #     p text
  #   </p>
  #   <div>
  #     more div text
  #   </div>
  #   div text after
  # </div>

  # make our tree
  def parser_script



  end


end


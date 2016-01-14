Tag = Struct.new(:text, :type, :classes, :id, :name, :children, :parent, :closing)

class DomParser

  def initialize
    @html_string = File.open("test.html").readlines[1..-1].map(&:strip).join
    @root = parse_tag
    @depth = 0
  end

  #returns the top level tag
  def parse_tag
    tag = Tag.new
    opening_tag = @html_string.match(/^<.*?>/).to_s

    tag_type_regex = /<[a-z]*[0-9]*/
    class_regex = /class=('|")[[a-z0-9]*\W*\s]*?('|")/
    id_regex = /id=('|")[[a-z0-9]*\W*]*?('|")/
    name_regex = /name=('|")[[a-z0-9]*\W*]*?('|")/
    self_closing_regex = /^(.*?>.*?)>/
    text_regex = />(\s*.*?\s*)</

    tag.type = opening_tag.match(tag_type_regex).to_s[1..-1]
    tag.classes = opening_tag.match(class_regex).to_s[7..-2].split(' ') if opening_tag.match(class_regex)
    tag.id = opening_tag.match(id_regex).to_s[4..-2]
    tag.name = opening_tag.match(name_regex).to_s[6..-2]
    tag.text = opening_tag.match(text_regex).to_s  # empty string or nil?
    tag.closing = @html_string.match(/<\/#{tag.type}>/).to_s
    p tag
  end

  # make our tree
  def parser_script(node)
    return if @html_string == ""
    # create a outermost Tag (with top level type)
    current_node = @root  

    # go through the html until we reach the closing tag
    # parse next level of open/close tags, set them as children to current_node

    # change current_node to be one of the children, recurse 


    # nested div's: have to count how many div's we have, n, and look for the nth closing tag
    #recurse the above two steps until cut html string doesn't have a tag anymore

  end

end

# tag = parse_tag("<h3 id='baz123' class='foo-bar foo bar test-ing' name='fozzie'>bla bla bla</h3>")
#
# p tag.type
# p tag.classes
# p tag.id
# p tag.name

#p file = File.open("test.html").readlines[1..-1].map(&:strip).join
game = DomParser.new
# game.parse_tag

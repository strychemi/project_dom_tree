Tag = Struct.new(:text, :type, :classes, :id, :name, :children, :parent, :closing)

class DomParser

  TAG_TYPE_REGEX = /<[a-z]*[0-9]*/
  CLASS_REGEX = /class=('|")[[a-z0-9]*\W*\s]*?('|")/
  ID_REGEX = /id=('|")[[a-z0-9]*\W*]*?('|")/
  NAME_REGEX = /name=('|")[[a-z0-9]*\W*]*?('|")/
  SELF_CLOSING_REGEX = /^(.*?>.*?)>/
  TEXT_REGEX = />(\s*.*?\s*)</
  OPEN_TAG_REGEX = /^<.*?>/

  attr_reader :root

  def initialize
    @html_string = File.open("test.html").readlines[1..-1].map(&:strip).join
    @root = set_tag_attributes
    @depth = 0
  end

  #returns the top level tag
  def set_tag_attributes
    tag = Tag.new(nil, nil, nil, nil, nil, [])
    opening_tag = @html_string.match(OPEN_TAG_REGEX).to_s
    # @html_string = @html_string[opening_tag.length..-1]

    tag.type = opening_tag.match(TAG_TYPE_REGEX).to_s[1..-1]
    tag.classes = opening_tag.match(CLASS_REGEX).to_s[7..-2].split(' ') if opening_tag.match(CLASS_REGEX)
    tag.id = opening_tag.match(ID_REGEX).to_s[4..-2]
    tag.name = opening_tag.match(NAME_REGEX).to_s[6..-2]
    tag.text = opening_tag.match(TEXT_REGEX).to_s  # empty string or nil?
    tag.closing = @html_string.match(/<\/#{tag.type}>/).to_s
    p tag
  end

  def get_children(node)
    #set_tag_attributes
    search_string = @html_string[node.type.length+2..-(node.closing.length+1)]
    
  end

  # make our tree
  def parser_script
    return if @html_string == ""
    # create a outermost Tag (with top level type)
    current_node = @root

    # go through the html until we reach the closing tag
    # parse next level of open/close tags, set them as children to current_node
    while next_child = set_tag_attributes
      current_node.children << next_child
    end
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
#game.parser_script
puts game.get_children(game.root)
# game.parse_tag

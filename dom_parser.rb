require_relative 'tag.rb'

Tag = Struct.new(:text, :type, :classes, :id, :name, :children, :parent, :closing, :depth)


class DomParser

  TAG_TYPE_REGEX = /<[a-z]*[0-9]*/
  CLASS_REGEX = /class=('|")[[a-z0-9]*\W*\s]*?('|")/
  ID_REGEX = /id=('|")[[a-z0-9]*\W*]*?('|")/
  NAME_REGEX = /name=('|")[[a-z0-9]*\W*]*?('|")/
  TEXT_REGEX = />(\s*.*?\s*)</

  ALL_TAG_REGEX = /(<[a-z]*.*?>)/
  OPEN_TAG_REGEX = /<[a-z].*?>/
  # SELF_CLOSING_REGEX = /^(.*?>.*?)>/
  ROOT_CLOSING = /<\/html>/

  attr_reader :root, :tag_list

  def initialize
    @html_string = File.open("test.html").readlines[1..-1].map(&:strip).join
    @root = nil
    @depth = 0
    @tag_list = nil
  end

  # make an array of all tags
  # every time we hit a new opening tag, depth increases by 1 AND we set typ, classes, id, name, text, depth
  # every time we hit a closing tag, depth decreases by 1

  def find_all_tags
    depth = 0
    @tag_list = @html_string.scan(ALL_TAG_REGEX).map {|array| array[0]}
    tag_structs = []
    # for each opening tag: generate Tag, set attributes, increase depth by 1
    @tag_list.each do |tag|
      if tag.match(OPEN_TAG_REGEX)
        tag_structs << set_tag_attributes(tag, depth)
        depth += 1
      # for each closing tag, decrease depth by 1
      else
        depth -= 1
      end
    end
    p tag_structs
  end


  def set_tag_attributes(tag_info, depth)
    new_tag = Tag.new(nil, nil, nil, nil, nil, [])

    new_tag.type = tag_info.match(TAG_TYPE_REGEX).to_s[1..-1]
    new_tag.classes = tag_info.match(CLASS_REGEX).to_s[7..-2].split(' ') if tag_info.match(CLASS_REGEX)
    new_tag.id = tag_info.match(ID_REGEX).to_s[4..-2]
    new_tag.name = tag_info.match(NAME_REGEX).to_s[6..-2]
    new_tag.text = tag_info.match(TEXT_REGEX).to_s
    new_tag.depth = depth
    # tag.closing = @html_string.match(/<\/#{tag.type}>/).to_s

    return new_tag
  end

end

game = DomParser.new
game.find_all_tags
Tag = Struct.new(:type, :classes, :id, :name, :text, :children, :depth)

class DomParser

  REGX = {
    type: /<[a-z]*[0-9]*/,
    class: /class=('|")[[a-z0-9]*\W*\s]*?('|")/,
    id: /id=('|")[[a-z0-9]*\W*]*?('|")/,
    name: /name=('|")[[a-z0-9]*\W*]*?('|")/,
    text: />(\s*.*?\s*)</,
    tag: /(<[a-z]*.*?>)/,
    open_tag: /<[a-z].*?>/
  }

  def initialize
    @html = File.open("test.html").readlines[1..-1].map(&:strip).join
    @document = nil
    @tag_array = nil
    @tag_structs = []
  end

  #main method, runs everything to build tree datastructure
  def build_tree
    read_tags
    #set root note (called document)
    @document = @tag_structs[0]
    set_children
  end

  #scans @html string and extracts tags
  def read_tags
    depth = 0
    @tag_array = @html.scan(REGX[:tag]).map {|array| array[0]}
    # for each opening tag: generate Tag, set attributes, increase depth by 1
    @tag_array.each do |tag|
      if tag.match(REGX[:open_tag])
        @tag_structs << parse_tag(tag, depth)
        depth += 1
      # for each closing tag, decrease depth by 1
      else
        depth -= 1
      end
    end
  end

  #sets appropriate edges between parent and child nodes
  def set_children
    #start current_node at root
    current_node = @document
    current_depth = current_node.depth
    #iterate through tag_
    @tag_structs[0..-2].each_with_index do |tag, index|
      next_node = @tag_structs[index+1]
      next_depth = next_node.depth
      if current_depth < next_depth
        current_node.children << next_node
        current_node = next_node
      end
    end
  end

  #parsing tag attributes from input string, depth is given as argument
  def parse_tag(string, depth)
    new_tag = Tag.new(nil, nil, nil, nil, nil, [])

    new_tag.type = string.match(REGX[:type]).to_s[1..-1]
    new_tag.classes = string.match(REGX[:class]).to_s[7..-2].split(' ') if string.match(REGX[:class])
    new_tag.id = string.match(REGX[:id]).to_s[4..-2]
    new_tag.name = string.match(REGX[:name]).to_s[6..-2]
    new_tag.text = string.match(REGX[:text]).to_s
    new_tag.depth = depth

    return new_tag
  end

  #print tags nicely
  def render
    @tag_structs.each do |tag|
      print " " * tag.depth
      puts tag.type
    end
  end

end

game = DomParser.new
game.build_tree
game.render

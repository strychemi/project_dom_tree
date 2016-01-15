Tag = Struct.new(:type, :classes, :id, :text, :children, :depth)

class DomParser

  REGX = {
    type: /<\w*/,
    class: /class=('|").*?('|")/,
    id: /id=('|").*?('|")/,
    left_text: /^.*?</,
    left_tag: /^<[a-z]*.*?>/,
    open_tag: /<[a-z].*?>/
  }

  def initialize(file)
    @html = File.open(file).readlines[1..-1].map(&:strip).join
    @document = nil
    @tags = []
  end

  #main method, runs everything to build tree datastructure
  def build_tree
    generate_node_array
    @document = @tags[0] #root node
    set_children
  end

  #scans @html string and reads in tags and text
  def generate_node_array
    depth = 0
    string_array = html_string_array
    puts string_array
    #for each opening tag: generate Tag, set attributes, increase depth by 1
    string_array.each do |tag|
      if tag.match(REGX[:open_tag])
        @tags << parse_tag(tag, depth)
        depth += 1
      #for each closing tag, decrease depth by 1
      else
        depth -= 1
      end
    end
  end

  #converts @html to a string array
  def html_string_array
    result = []
    #cut parts from @html string and save it in array form
    while @html.length > 0
      #if tag is at beginning of string, save it and cut from @html
      if tag_match = REGX[:left_tag].match(@html)
        string = tag_match.to_s
        result << string
        @html = @html[string.length..-1]
      #elsif text is at beginning of string, save it and cut from @html
      elsif text_match = REGX[:left_text].match(@html)
        string = text_match.to_s[0..-2]
        result << string
        @html = @html[string.length..-1]
      end
    end
    return result
  end

  #sets appropriate edges between parent and child nodes
  def set_children
    #start current_node at root
    current_node = @document
    current_depth = current_node.depth
    #iterate through tags
    @tags[0..-2].each_with_index do |tag, index|
      next_node = @tags[index+1]
      next_depth = next_node.depth
      if current_depth < next_depth
        current_node.children << next_node
        current_node = next_node
      end
    end
  end

  #parsing tag attributes from input string, depth is given as argument
  def parse_tag(string, depth)
    new_tag = Tag.new(nil, nil, nil, nil, [])

    new_tag.type = string.match(REGX[:type]).to_s[1..-1]
    new_tag.classes = string.match(REGX[:class]).to_s[7..-2].split(' ') if string.match(REGX[:class])
    new_tag.id = string.match(REGX[:id]).to_s[4..-2]
    new_tag.depth = depth

    return new_tag
  end

  #print tags nicely
  def render
    @tags.each do |tag|
      #print " " * tag.depth
      puts tag.type
    end
  end

end

game = DomParser.new("test.html")
game.build_tree
#game.render

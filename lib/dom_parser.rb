Tag = Struct.new(:type, :classes, :id, :children, :depth, :parent)
Text = Struct.new(:text, :depth)

class DomParser

  REGX = {
    type: /<\w*/,
    class: /class=('|").*?('|")/,
    id: /id=('|").*?('|")/,
    left_text: /^.*?</,
    left_tag: /^<[a-z]*.*?>/,
    open_tag: /<[a-z].*?>/,
    close_tag: /<\/.*?>/
  }

  def initialize(file)
    @html = File.open(file).readlines[1..-1].map(&:strip).join
    @document = nil
    @string_array = []
    @parsed = []
  end

  #main method, runs everything to build tree datastructure
  def build_tree
    @string_array = html_string_array
    generate_node_tree
    @document = @parsed[0] #set root node
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

  #scans @html string and reads in tags and text
  def generate_node_tree
    depth = 0
    text_depth = false
    #for each opening tag: generate Tag, set attributes, increase depth by 1
    @string_array.each do |element|
      if element.match(REGX[:open_tag])
        @parsed << parse_tag(element, depth)
        #iterate back until you hit a tag with depth higher than current one by 1, then set it's child to the most recently created tag
        (@parsed.length-2).downto(0).each do |x|
          if @parsed[x].depth + 1 == depth
            @parsed[x].children << @parsed[-1]
            break
          end
        end
        depth += 1
        #for each closing tag, decrease depth by 1
      elsif element.match(REGX[:close_tag])
        depth -= 1
        text_depth = true
      #if element is a text put it in tag attribute of appropriate depth
      else
        text_struct = Text.new(element, depth)
        if text_depth
          @parsed[-2].children << text_struct
        else
          @parsed.last.children << text_struct
        end
        text_depth = false
      end
    end
  end

  #parsing tag attributes from input string, depth is given as argument
  def parse_tag(string, depth)
    new_tag = Tag.new(nil, nil, "", [])

    new_tag.type = string.match(REGX[:type]).to_s[1..-1]
    new_tag.classes = string.match(REGX[:class]).to_s[7..-2].split(' ') if string.match(REGX[:class])
    new_tag.id = string.match(REGX[:id]).to_s[4..-2]
    new_tag.depth = depth

    return new_tag
  end

  #print tags nicely
  def render
    @parsed.each do |tag|
      puts "#{" " * tag.depth} #{tag.type} #{tag.depth}"
      #puts "#{" " * tag.depth} #{tag.text} #{tag.depth}" if tag.text != ""
    end
  end

end

# game = DomParser.new("test.html")
# game.build_tree
# game.render

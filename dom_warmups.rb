Tag = Struct.new(:type, :classes, :id, :name)

#returns Hash or Struct after parsing HTML
def parse_tag(input)

  tag = Tag.new

  header_tag = /<h[0-9]>.*?/
  paragraph_tag = /<p.*?/
  tag_type_regex = /<[a-z]*[0-9]*/
  class_regex = /class='[[a-z]*\s]*'/

  tag.type = input.match(tag_type_regex).to_s[1..-1]
  tag.classes = input.match(class_regex).to_s[7..-2].split(' ')

  return tag
end

tag = parse_tag("<h3 class='foo bar' id='baz'>")

p tag.type
p tag.classes

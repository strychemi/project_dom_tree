Tag = Struct.new(:type, :classes, :id, :name)

#returns Hash or Struct after parsing HTML
def parse_tag(input)

  tag = Tag.new

  tag_type_regex = /<[a-z]*[0-9]*/
  class_regex = /class=('|")[[a-z0-9]*\W*\s]*?('|")/
  id_regex = /id=('|")[[a-z0-9]*\W*]*?('|")/
  name_regex = /name=('|")[[a-z0-9]*\W*]*?('|")/

  tag.type = input.match(tag_type_regex).to_s[1..-1]
  tag.classes = input.match(class_regex).to_s[7..-2].split(' ')
  tag.id = input.match(id_regex).to_s[4..-2]
  tag.name = input.match(name_regex).to_s[6..-2]
  return tag
end

tag = parse_tag("<h3 id='baz123' class='foo-bar foo bar test-ing' name='fozzie'>")

p tag.type
p tag.classes
p tag.id
p tag.name

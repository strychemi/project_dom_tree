Tag = Struct.new(:type, :classes, :id, :name)

#returns Hash or Struct after parsing HTML
def parse_tag(input)
  <h[0-9]>.*?</h[0-9]>

end

tag = parse_tag("<p class='foo bar' id='baz'>")

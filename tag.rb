require_relative 'dom_parser.rb'

class Tag < Struct.new(:text, :type, :classes, :id, :name, :children, :parent, :closing, :depth)

  def closing_tag?(depth)
    Tag.depth == depth
  end



end
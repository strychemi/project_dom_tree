require_relative 'dom_parser.rb'

class NodeRenderer

  def initialize(tree)
    raise ArgumentError, "not a tag tree!" unless tree.is_a?(Tag)
    @root = tree
    @node_count = 0
  end


end

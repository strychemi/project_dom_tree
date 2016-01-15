require_relative 'dom_parser.rb'

class NodeRenderer

  def initialize(tree)
    raise ArgumentError, "not a tag tree!" unless tree.is_a?(Tag)
    @root = tree
    @node_count = 0
    @node_types = []
  end

  def render(node)
    raise ArgumentError, "input must be tag!" unless node.is_a?(Tag) || node.nil?
    #iterative DFS search approach
    queue = []
    current_node = @root
    until node == current_node

    end
    #print shit out

  end

  def count_nodes(root, node_count=0)
    return 1 if root.children.empty?
    puts root.type
    puts root.depth
    puts root.children.length
    # root.children.each do |child|
    #   1 + count_nodes(child)
    # end

  end
end

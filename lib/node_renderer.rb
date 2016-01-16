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

  def count_nodes(current_node)

    @node_count += 1 if current_node.children.empty?
    current_node.children.each do |child|
      @node_count += 1
      count_nodes(child)
    end

  end

  def render_tree(node)
    puts "#{"  " * node.depth} #{node.type} #{node.depth}"
    #puts "#{"  " * node.depth} #{node.text} #{node.depth}" if node.text != ""
    node.children.each do |child|
      render_tree(child)
    end
  end

end

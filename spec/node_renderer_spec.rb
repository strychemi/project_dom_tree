require 'node_renderer'
require 'dom_parser.rb'

describe NodeRenderer do

  let(:game) { DomParser.new("./lib/test.html") }

  describe '#initialize' do
    it 'raises an error if not given a tag tree' do
      expect{ NodeRenderer.new("hi") }.to raise_error(ArgumentError, "not a tag tree!")
    end

    it 'initializes @root to input tree' do
      game.build_tree
      node_tree = NodeRenderer.new(game.instance_variable_get(:@document))
      expect(node_tree.instance_variable_get(:@root)).to be_a(Tag)
    end

    it 'initializes @node_count to 0' do
      game.build_tree
      node_tree = NodeRenderer.new(game.instance_variable_get(:@document))
      expect(node_tree.instance_variable_get(:@node_count)).to eq(0)
    end

    it 'initializes @node_types to empty array' do
      game.build_tree
      node_tree = NodeRenderer.new(game.instance_variable_get(:@document))
      expect(node_tree.instance_variable_get(:@node_types)).to eq([])
    end
  end

  describe '#count_nodes' do
    it 'counts nodes in a tree correctly' do
      game.build_tree
      root = game.instance_variable_get(:@document)
      node_tree = NodeRenderer.new(root)
      expect(node_tree.count_nodes(root)).to eq(25)
    end
  end

  describe '#render' do
    it 'raises error if input is not a tag node' do
      game.build_tree
      node_tree = NodeRenderer.new(game.instance_variable_get(:@document))
      expect{ node_tree.render("hi") }.to raise_error(ArgumentError, "input must be tag!")
    end

    it 'outputs total nodes in subtree below current node'
    it 'counts each node type in subtree below current node'
    it 'obtains all of current node attributes'
  end


end

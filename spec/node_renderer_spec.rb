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
  end

  
end

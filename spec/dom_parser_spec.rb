require 'dom_parser'

describe DomParser do
  let(:game) { DomParser.new("./lib/test.html") }

  describe '#initialize' do
    it 'initializes root variable @document to nil' do
      expect(game.instance_variable_get(:@document)).to eq(nil)
    end

    it 'initializes string array to empty array' do
      expect(game.instance_variable_get(:@string_array)).to eq([])
    end

    it 'initializes parsed array to empty array' do
      expect(game.instance_variable_get(:@parsed)).to eq([])
    end
  end

  describe '#html_string_array' do
    it 'converts html string to an array of parsed elements' do
      game.instance_variable_set(:@html, "<p>Before text <span>mid text (not included in text attribute of the paragraph tag)</span> after text.</p>")
      result = ["<p>","Before text ", "<span>", "mid text (not included in text attribute of the paragraph tag)", "</span>", " after text.", "</p>"]
      expect(game.html_string_array).to eq(result)
    end
  end

  describe '#parse_tag' do
    it 'parses a tag type with no attributes' do
      tag = game.parse_tag("<html>", 0)
      expect(tag.type).to eq("html")
    end

    it 'parses a tag with clasess' do
      tag = game.parse_tag("<div class='nav nav-collapse'>", 0)
      expect(tag.classes).to eq(["nav","nav-collapse"])
    end

    it 'parses a tag with an id' do
      tag = game.parse_tag("<div id='17'>", 0)
      expect(tag.id).to eq("17")
    end

    it 'parses a tag with a depth' do
      tag = game.parse_tag("<div id='17'>", 18)
      expect(tag.depth).to eq(18)
    end

    it 'parses a tag with a classes, an id, and depth' do
      tag = game.parse_tag("<li class='bold funky-important' id='poop'>", 3)
      expect(tag.depth).to eq(3)
    end
  end

  describe '#generate_node_tree' do
    it 'makes an array of 2 nodes' do
      game.instance_variable_set(:@string_array, ["<p>","text", "</p>"])
      game.generate_node_tree
      result = []
      result << game.parse_tag("<p>", 0)
      result.last.children << Text.new("text", 1)
      expect(game.instance_variable_get(:@parsed)[0]).to eq(result[0])
    end

    it 'makes an array of multiple nodes from nested tags' do
      game.instance_variable_set(:@string_array, ["<p>","Before text","<span>","span-text","</span>"," after text.", "</p>"])

      result = []

      result << game.parse_tag("<p>", 0)
      result.last.children << Text.new("Before text", 1)

      span_tag = game.parse_tag("<span>", 1)
      span_tag.children << Text.new("span-text", 2)

      result[0].children << span_tag
      result[0].children << Text.new(" after text.", 1)

      game.generate_node_tree
      expect(game.instance_variable_get(:@parsed)[0]).to eq(result[0])
    end
  end
end

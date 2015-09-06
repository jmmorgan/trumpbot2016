require 'rails_helper'

describe CategoryTree do
  let(:category_tree) { CategoryTree.new }
  let(:pattern) { double('pattern', to_s: 'PATTERN ROOT')}
  let(:root_category) { double('category', pattern: pattern) }

  before do
    if (root_category)
      category_tree.append(root_category)
    end
  end

  describe '#append' do
    let(:new_pattern) { double('pattern', to_s: 'PATTERN NEW')}
    let(:new_category) { double('new_category', pattern: new_pattern) }

    before do
      category_tree.append(new_category)
    end

    context 'root category is not set' do
      let(:root_category) { nil }

      it 'sets the root category' do
        expect(category_tree.root.category).to eq new_category 
      end
    end

    it 'appends the category to the current path' do
      root = category_tree.root
      expect(root.category).to eq root_category
      expect(root.children.first.category).to eq new_category
    end

    context 'adding category already in the path' do

      it 'should raise an error' do
        expect{category_tree.append(root_category)}.to raise_error(/Circular reference/)
      end
    end

  end

  describe '#branch' do
    let(:branch) { category_tree.branch }
    let(:new_pattern) { double('pattern', to_s: 'PATTERN NEW')}
    let(:new_category) { double('new_category', pattern: new_pattern) }

    before do
      branch.append(new_category)
    end

    it 'changes the current path' do
      expect(branch.current_path.map(&:category)).to eq [root_category, new_category]
      expect(category_tree.current_path.map(&:category)).to eq [root_category]
    end
  end

  describe '#paths' do
    let(:branch1) { category_tree.branch }
    let(:pattern1) { double('pattern1', to_s: 'PATTERN ONE')}
    let(:new_category1) { double('new_category1',  pattern: pattern1) }
    let(:branch2) { category_tree.branch }
    let(:pattern2) { double('pattern2', to_s: 'PATTERN TWO')}
    let(:new_category2) { double('new_category2', pattern: pattern2) }


    before do
      branch1.append(new_category1)
      branch2.append(new_category2)
    end

    it 'returns all the paths' do
      expect(category_tree.paths.map(&:last).map(&:category)).to eq [new_category1, new_category2]
    end
  end

  describe '#to_s' do
    let(:expected_string) { 
      "[0] PATTERN ROOT\n  [1] PATTERN ONE\n[0] PATTERN ROOT\n  [1] PATTERN TWO\n"
    }
    let(:branch1) { category_tree.branch }
    let(:pattern1) { double('pattern1', to_s: 'PATTERN ONE')}
    let(:new_category1) { double('new_category1',  pattern: pattern1) }
    let(:branch2) { category_tree.branch }
    let(:pattern2) { double('pattern2', to_s: 'PATTERN TWO')}
    let(:new_category2) { double('new_category2', pattern: pattern2) }


    before do
      branch1.append(new_category1)
      branch2.append(new_category2)
    end

    it 'returns formatted output of matched patterns' do
      expect(category_tree.to_s).to eq expected_string
    end
  end

end

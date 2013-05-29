require 'word_filter'

describe WordFilter, 'load files' do
  it 'should be able to load external dictionary files' do
    filter = WordFilter::Filter.new
    filter.filterInit("lib/dictionary.txt", "lib/badwords.txt")
  end

  it 'should return an array of words from the dictionary file' do
    filter = WordFilter::Filter.new
    filter.filterInit("lib/dictionary.txt", "lib/badwords.txt")
    filter.goodWords.is_a?(Array).should be_true
  end

  it 'should return a regex from the badwords list' do
    filter = WordFilter::Filter.new
    filter.filterInit("lib/dictionary.txt", "lib/badwords.txt")
    filter.badWordsRegex.is_a?(Regexp).should be_true
  end
end

describe WordFilter, 'set filter level' do
  it 'should be able to set a filter level' do
    filter = WordFilter::Filter.new
    filter.filterInit("lib/dictionary.txt", "lib/badwords.txt")
    filter.filterLevel = WordFilter::Filter::SWAPPABLE_AND_REPEATED_VOWELS_INCLUDING_NONE
  end
end

describe WordFilter, 'filter words' do
  it 'should return zero if the input is a valid word' do
    filter = WordFilter::Filter.new
    filter.filterInit("lib/dictionary.txt", "lib/badwords.txt")
    filter.filterLevel = WordFilter::Filter::SWAPPABLE_AND_REPEATED_VOWELS_INCLUDING_NONE
    filter.filterString('hi').zero?.should be_true
  end

  it 'should not return 7 if the input is a bad word' do
    filter = WordFilter::Filter.new
    filter.filterInit("lib/dictionary.txt", "lib/badwords.txt")
    filter.filterLevel = WordFilter::Filter::SWAPPABLE_AND_REPEATED_VOWELS_INCLUDING_NONE
    filter.filterString('bitch').should == 7
  end

  it 'should not return nil if the input is a invalid word' do
    filter = WordFilter::Filter.new
    filter.filterInit("lib/dictionary.txt", "lib/badwords.txt")
    filter.filterLevel = WordFilter::Filter::SWAPPABLE_AND_REPEATED_VOWELS_INCLUDING_NONE
    filter.filterString('asdasd').should be_nil
  end
end

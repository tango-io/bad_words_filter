# WordFilter

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'word_filter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install word_filter

## Usage
 This gem work with a dictionary list and a badwords list to be able to filter the bad words
 
 Use example of the Gem
 testFilter = WordFilter.new
 testFilter.filterInit("lib/assets/dictionary.txt", "lib/assets/badwords.txt")
 testFilter.filterLevel = WordFilter::SWAPPABLE_AND_REPEATED_VOWELS_INCLUDING_NONE
 input = "I went to school and some beeeestard stole my lunch"
 puts testFilter.filterString(input)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

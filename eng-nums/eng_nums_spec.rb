$LOAD_PATH.unshift File.expand_path('../.', __FILE__)

require 'byebug'
require 'eng_nums'

SIMPLE_TEST_NUMBERS = %w(
  zero one two three four
  five six seven eight nine

  ten eleven twelve thirteen fourteen
  fifteen sixteen seventeen eighteen nineteen
)

describe '#to_english_number' do
  (0..19).each do |number|
    expected_english_number = SIMPLE_TEST_NUMBERS[number]

    it "converts #{number} to #{expected_english_number}" do
      expect(to_english_number(number)).to eq(expected_english_number )
    end
  end

  it 'converts 20 to twenty' do
    expect(to_english_number(20)).to eq('twenty')
  end

  it 'converts 21 to twenty-one' do
    expect(to_english_number(21)).to eq('twenty-one')
  end

  it 'converts 25 to twenty-five' do
    expect(to_english_number(25)).to eq('twenty-five')
  end

  it 'converts 30 to thirty' do
    expect(to_english_number(30)).to eq('thirty')
  end

  it 'converts 42 to fourty-two' do
    expect(to_english_number(42)).to eq('fourty-two')
  end

  it 'converts other 2-digit numbers' do
    expect(to_english_number(33)).to eq('thirty-three')
    expect(to_english_number(56)).to eq('fifty-six')
    expect(to_english_number(57)).to eq('fifty-seven')
    expect(to_english_number(72)).to eq('seventy-two')
    expect(to_english_number(99)).to eq('ninety-nine')
  end
end

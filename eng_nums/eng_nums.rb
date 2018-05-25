SIMPLE_NUMBERS = %w(
  zero one two three four
  five six seven eight nine

  ten eleven twelve thirteen fourteen
  fifteen sixteen seventeen eighteen nineteen
)

TENS = %w(
  \'' \'' twenty thirty fourty fifty sixty seventy eighty ninety
)

def to_english_number(number)
  if number >= 20
    first_part  = TENS[number / 10 ]
    second_part = SIMPLE_NUMBERS[number % 10]

    return first_part + (second_part == 'zero' ? '' : "-#{second_part}")
  end

  SIMPLE_NUMBERS[number]
end

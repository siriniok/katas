class Game
  MAX_PINS  = 10
  FRAMES    = 1..10

  def initialize
    @rolls = []
  end

  def roll(pins)
    @rolls << pins
  end

  def score
    strikes = 0

    FRAMES.reduce(0) do |score, frame_index|
      r1, r2, r3  = three_next_rolls(frame_index - 1, strikes)
      bonus_score = 0

      if strike?(r1)
        frame = [r1]
        frame_sum = sum_frame(frame)
        bonus_score = r2 + r3
        strikes += 1
      else
        frame      = [r1, r2]
        frame_sum = sum_frame(frame)

        bonus_score = r3 if spare?(frame, frame_sum)
      end

      score + frame_sum + bonus_score
    end
  end

  private
  ############################################################################

  def three_next_rolls(frame_index, strikes)
    first = frame_index * 2 - strikes
    last  = frame_index * 2 + 2
    @rolls[first..last]
  end

  def sum_frame(frame)
    frame.reduce(:+)
  end

  def spare?(frame, frame_sum)
    frame.first != MAX_PINS && frame_sum == MAX_PINS
  end

  def strike?(pins)
    pins == MAX_PINS
  end
end

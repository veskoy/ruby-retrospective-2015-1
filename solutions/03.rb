module Enumerable
  def prime?(number)
    return false if number <= 1
    (2..Math.sqrt(number)).each { |i| return false if number % i == 0 }
    true
  end
end

class RationalSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    dividend, divisor, numbers = 1, 1, 0
    saved_dividend, saved_divisor = 1, 1
    sequence = []

    while numbers < @limit
      rational_number = Rational(dividend, divisor).rationalize
      unless sequence.include?(rational_number)
        sequence << rational_number
        yield rational_number
      else
        numbers -= 1
      end

      if (saved_dividend+saved_divisor) % 2 == 0 then dividend += 1 else divisor += 1 end
      if (saved_dividend+saved_divisor) % 2 == 0 and not divisor == 1 then divisor -= 1 end
      if not ((saved_dividend+saved_divisor) % 2 == 0) and not dividend == 1 then dividend -= 1 end

      saved_dividend = dividend
      saved_divisor = divisor

      numbers += 1
    end
  end
end

class PrimeSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    numbers, current_number = 0, 0

    while numbers < @limit
      if prime?(current_number)
        yield current_number
        numbers += 1
      end
      current_number += 1
    end
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(limit, first: nil, second: nil)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    numbers, skip = 0, false

    if not @first == nil and not @second == nil
      current, previous, skip = @second, @first, true
      yield @first
      yield @second
      numbers += 2
    else
      current, previous = 1, 0
    end

    while numbers < @limit
      if skip
              skip = false
      else
        yield current
        numbers += 1
      end
      current, previous = current + previous, current
    end
  end
end

module DrunkenMathematician
  module_function

  def prime?(number)
    return false if number <= 1
    (2..Math.sqrt(number)).each { |i| return false if number % i == 0 }
    true
  end

  def meaningless(n)
    numbers = RationalSequence.new(n).to_a
    first_group, second_group = [], []
    numbers.each { |a|
                    string = (a.to_s).split('/')
                    if prime?(string[0].to_i) or prime?(string[1].to_i)
                      first_group << a
                    else
                      second_group << a
                    end
                 }
    if first_group.empty? then first_group << (1/1) end
    if second_group.empty? then second_group << (1/1) end
    first_group.reduce(:*)/second_group.reduce(:*)
  end

  def aimless(n)
    return 0 if n == 0
    numbers = PrimeSequence.new(n).to_a
    previous, group = 0, []
    numbers.each { |a|
                   a = if numbers.length % 2 == 0 then a else 1 end
                   if previous == 0
                     previous = a
                   else
                     group << Rational(previous, a)
                     previous = 0
                     end
                 }
    group.reduce(:+)
  end

  def worthless(n)
    return [] if n == 0
    fibonacci = FibonacciSequence.new(n).to_a.last
    i = 0
    while(RationalSequence.new(i).to_a.reduce(:+).to_i <= fibonacci)
      i += 1
    end
    i -= 1
    RationalSequence.new(i).to_a
  end
end

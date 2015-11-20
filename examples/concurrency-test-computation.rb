#!/usr/bin/env ruby

require 'concurrent'
require 'benchmark'

COUNT = 10
NUMBERS = 1_000_000.times.collect { rand }

# obviously contrived example
def sum(numbers)
  total = 0
  numbers.size.times {|i| total += numbers[i]}
  total
end

def serial_sum(numbers, count)
  count.times { sum(numbers) }
end

def concurrent_sum(numbers, count)
  futures = count.times.collect do
    Concurrent::Future.execute { sum(numbers) }
  end
  futures.collect { |future| future.value }
end

# make sure there's no unfair I/O caching going on
# and also warm up the global thread pool
puts 'Warm up...'
p concurrent_sum(NUMBERS, 1)
puts "\n"

Benchmark.bmbm do |bm|
  bm.report('serial') do
    serial_sum(NUMBERS, COUNT)
  end

  bm.report('concurrent') do
    concurrent_sum(NUMBERS, COUNT)
  end
end

__END__

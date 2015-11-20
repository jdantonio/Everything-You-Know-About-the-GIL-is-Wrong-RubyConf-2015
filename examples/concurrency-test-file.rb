#!/usr/bin/env ruby

require 'concurrent'
require 'benchmark'
require 'open-uri' # for open(uri)

FILE = 'file-100.txt'
COUNT = 50

def slurp(file = FILE)
  IO.read File.join(File.dirname(__FILE__), file)
end

def serial_slurp(n = COUNT)
  latch = Concurrent::CountDownLatch.new(n)
  n.times { slurp; latch.count_down }
  latch.wait
end

def concurrent_slurp(n = COUNT)
  latch = Concurrent::CountDownLatch.new(n)
  n.times do
    Concurrent::Future.execute { slurp; latch.count_down }
  end
  latch.wait
end

# make sure there's no unfair I/O caching going on
# and also warm up the global thread pool
puts "Warm up #{FILE} for a #{COUNT} count..."
slurp
COUNT.times { Concurrent::Future.execute { nil } }
puts "\n"

Benchmark.bmbm do |bm|
  bm.report('serial') do
    serial_slurp(COUNT)
  end

  bm.report('concurrent') do
    concurrent_slurp(COUNT)
  end
end

__END__

$ dd if=/dev/urandom of=file-100.txt bs=1048576 count=100
100+0 records in
100+0 records out
104857600 bytes transferred in 7.543924 secs (13899610 bytes/sec)

ruby 2.2.3p173 (2015-08-18 revision 51636) [x86_64-darwin14]

$ ./concurrency-test-file.rb
Warm up file-100.txt for a 50 count...

Rehearsal ----------------------------------------------
serial       0.060000   2.230000   2.290000 (  2.280582)
concurrent   0.160000   4.420000   4.580000 (  1.472047)
------------------------------------- total: 6.870000sec

                 user     system      total        real
serial       0.030000   2.080000   2.110000 (  2.115197)
concurrent   0.170000   3.820000   3.990000 (  1.265867)

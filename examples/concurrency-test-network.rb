#!/usr/bin/env ruby

require 'concurrent'
require 'benchmark'
require 'open-uri' # for open(uri)

# http://www.bloomberg.com/visual-data/best-and-worst/highest-risk-adjusted-returns-in-us-tech-companies
SYMBOLS = ['MA', 'PCLN', 'ADP', 'V', 'TSS', 'FISV', 'EBAY', 'PAYX', 'WDC', 'SYMC',
           'AAPL', 'AMZN', 'KLAC', 'FNFV', 'XLNX', 'MSI', 'ADI', 'VRSN', 'CA', 'YHOO']
YEAR = 2014

def get_year_end_closing(symbol, year)
  uri = "http://ichart.finance.yahoo.com/table.csv?s=#{symbol}&a=01&b=04&c=#{year}&d=01&e=14&f=#{year+1}&g=d&ignore=.csv "
  data = open(uri) {|f| f.collect{|line| line.strip } }
  data[1].split(',')[4].to_f
end

def serial_get_year_end_closings(year)
  SYMBOLS.collect do |symbol|
    get_year_end_closing(symbol, year)
  end
end

def concurrent_get_year_end_closings(year)
  futures = SYMBOLS.collect do |symbol|
    Concurrent::Future.execute { get_year_end_closing(symbol, year) }
  end
  futures.collect { |future| future.value }
end

# make sure there's no unfair I/O caching going on
# and also warm up the global thread pool
puts 'Warm up...'
p concurrent_get_year_end_closings(YEAR)
puts "\n"

Benchmark.bmbm do |bm|
  bm.report('serial') do
    serial_get_year_end_closings(YEAR)
  end

  bm.report('concurrent') do
    concurrent_get_year_end_closings(YEAR)
  end
end

__END__

ruby 2.2.3p173 (2015-08-18 revision 51636) [x86_64-darwin14]

Warm up...
  [87.139999, 1103.369995, 88.75, 269.630005, 37.09, 78.699997, 56.470001, 48.759998, 107.610001, 26.33, 127.080002, 381.829987, 63.639999, 12.59, 41.509998, 69.910004, 57.049999, 62.150002, 32.630001, 44.419998]

Rehearsal ----------------------------------------------
  serial       0.040000   0.020000   0.060000 (  7.049206)
concurrent   0.030000   0.010000   0.040000 (  0.158555)
------------------------------------- total: 0.100000sec

user     system      total        real
serial       0.050000   0.020000   0.070000 (  2.693514)
concurrent   0.030000   0.010000   0.040000 (  0.127137)

jruby 1.7.19 (1.9.3p551) 2015-01-29 20786bd on Java HotSpot(TM) 64-Bit Server VM 1.8.0_31-b13 +jit [darwin-x86_64]

Warm up...
  [87.139999, 1103.369995, 88.75, 269.630005, 37.09, 78.699997, 56.470001, 48.759998, 107.610001, 26.33, 127.080002, 381.829987, 63.639999, 12.59, 41.509998, 69.910004, 57.049999, 62.150002, 32.630001, 44.419998]

Rehearsal ----------------------------------------------
  serial       0.960000   0.060000   1.020000 (  5.430000)
concurrent   1.230000   0.060000   1.290000 (  2.420000)
------------------------------------- total: 2.310000sec

user     system      total        real
serial       0.280000   0.040000   0.320000 (  3.116000)
concurrent   0.610000   0.050000   0.660000 (  1.572000)

#!/usr/bin/env ruby

str = "Jerry"

t1 = Thread.new(str) do |s|
  print "Starting thread 1\n"
  sleep rand(2)
  print "Thread 1 is making a change\n"
  s.upcase!
  print "Thread 1 has made a change\n"
  sleep rand(2)
  print "Thread 1 #{s}\n"
end

t2 = Thread.new(str) do |s|
  print "Starting thread 2\n"
  sleep rand(2)
  print "Thread 2 is making a change\n"
  s.downcase!
  print "Thread 2 has made a change\n"
  sleep rand(2)
  print "Thread 2 #{s}\n"
end

[t1, t2].each(&:join)

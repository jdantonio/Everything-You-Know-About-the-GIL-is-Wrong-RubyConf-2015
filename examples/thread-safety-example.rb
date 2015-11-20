#!/usr/bin/env ruby

str = "Jerry"

t1 = Thread.new(str) do |s|
  print "Starting thread 1\n"
  s1 = s.dup
  sleep rand(2)
  s1.gsub!(/r/, 'R')
  sleep rand(2)
  print "Thread 1 is making a change\n"
  s.gsub!(/^.*$/, s1)
  print "Thread 1 has made a change\n"
  sleep rand(2)
  print "Thread 1 #{s}\n"
end

t2 = Thread.new(str) do |s|
  print "Starting thread 2\n"
  s2 = s.dup
  sleep rand(2)
  s2.gsub!(/J/, 'j')
  sleep rand(2)
  print "Thread 2 is making a change\n"
  s.gsub!(/^.*$/, s2)
  print "Thread 2 has made a change\n"
  sleep rand(2)
  print "Thread 2 #{s}\n"
end

[t1, t2].each(&:join)

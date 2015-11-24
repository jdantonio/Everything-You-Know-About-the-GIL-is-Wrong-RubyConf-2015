# "Everything You Know About the GIL is Wrong"

This repo contains the slide deck and sample code from my [presentation](http://rubyconf.org/program#prop_1543) at RubyConf 2015.

The [video](http://confreaks.tv/videos/rubyconf2015-everything-you-know-about-the-gil-is-wrong) is available online at Confreaks.

## Abstract

> When a Rubyist hears "concurrency" they usually Google Elixir, Go, or even Node.js. Turns out, Ruby can be great for concurrency! The Global Interpreter Lock (GIL) does NOT prevent Ruby programs from performing concurrently. In this presentation we'll discuss the true meaning of concurrency, explore the inner-workings of the GIL, and gain a deeper understanding of how the GIL effects concurrent programs. Along the way we'll write a bunch of concurrent Ruby code, run it on multiple interpreters, and compare the results.

## Important Stuff

* The [video](http://confreaks.tv/videos/rubyconf2015-everything-you-know-about-the-gil-is-wrong) is available online at Confreaks.
* The slide deck is also [available online](http://www.slideshare.net/JerryDAntonio/everything-you-know-about-the-gil-is-wrong)
* Source repository for [concurrent-ruby](https://github.com/ruby-concurrency/concurrent-ruby)
* Sample code shown during the presentation:
  - [concurrency-test-network.rb](blob/master/examples/concurrency-test-network.rb) demonstrates the significant performance gain MRI Ruby is capable of when performing multi-threaded I/O operations
  - [shared-memory-example.rb](blob/master/examples/shared-memory-example.rb) is an example of the safety and correctness problems associated with shared memory concurrency
  - [thread-safety-example.rb](blob/master/examples/thread-safety-example.rb) is another example of thread safety and correctness issues
* The [slide deck](https://talks.golang.org/2012/waza.slide#1) from Rob Pike's "Concurrency is not Parallelism" presentation

# https://github.com/ko1/ruby/blob/ractor_parallel/doc/ractor.md
# ring example again

r = Ractor.current
(1..10).map{|i|
  r = Ractor.new r, i do |r, i|
    r.send Ractor.recv + "r#{i}"
  end
}

r.send "r0"
p Ractor.recv #=> "r0r10r9r8r7r6r5r4r3r2r1"

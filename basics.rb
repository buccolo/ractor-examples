puts "# Basics"

puts "## Pulling data"
r = Ractor.new do
  123
end
puts r.take # => 123

## Alternative way to pull data
r = Ractor.new do
  Ractor.yield 123
end
puts r.take # => 123

puts "## Receiving data"
doubler = Ractor.new do
  loop do
    i = Ractor.recv
    Ractor.yield i * 2
  end
end

doubler.send(5) 
doubler.send(100)
puts doubler.take #=> 10
puts doubler.take #=> 200

puts "## Ractors colab"
quadruple = Ractor.new doubler do |doubler|
  input = Ractor.recv
  doubler.send(input)
  double = doubler.take

  doubler.send double
  output = doubler.take 
  Ractor.yield output
end

quadruple << 4 # Ractor#<< is an alias of Reactor#send
puts quadruple.take #=> 16

puts "## Mutating objects"
reverser = Ractor.new do
  loop do
    name = Ractor.recv
    name.reverse!
    Ractor.yield name
  end
end

name = 'Bruno'
reverser.send name
puts reverser.take
puts name #=> 'Bruno' (string was dupped on send)

name2 = 'Matz'
reverser.send name2, move: true
puts reverser.take #=> 'ztaM'
begin 
  puts name2.reverse!
rescue => e
  puts e.message #=>  can not send any methods to a moved object
end

puts "## Scope"
begin
  outside_cannot_be_used = 123

  outsider = Ractor.new do
    outside_cannot_be_used
  end
  
  puts outsider.take
rescue => e
  puts e.message #=> Can not isolate a Proc because it can accesses outer variables. 
end


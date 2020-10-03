CPU_COUNT = 12

producers = CPU_COUNT.times.map do |index|
  Ractor.new do
    i = 0
    loop do
      Ractor.yield i += 1
    end
  end
end
producers.freeze

consumers = CPU_COUNT.times.map do |index|
  Ractor.new(producers, index) do |producers, index|
    loop do
      producer_index = (rand * CPU_COUNT).floor
      puts "Consumer #{index} // Producer #{producer_index} is processing job #{producers[producer_index].take}"
    end
  end
end

loop {}

CPU_COUNT = 12

producers = CPU_COUNT.times.map do |index|
  Ractor.new name: index.to_s do
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
      r, job = Ractor.select(*producers)
      puts "Consumer #{index} // Producer #{r.name} is processing job #{job}"
    end
  end
end

loop {}

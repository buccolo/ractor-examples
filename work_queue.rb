work_queue = Ractor.new do
  loop do
    Ractor.yield Ractor.recv
  end
end

CPU_COUNT = 12

ractors = CPU_COUNT.times.map do |index|
  Ractor.new(work_queue, index) do |work_queue, index|
    loop do
      puts "Worker #{index} is processing job #{work_queue.take}"
    end
  end
end

job_id = 0
loop do
  work_queue << job_id
  job_id += 1
end

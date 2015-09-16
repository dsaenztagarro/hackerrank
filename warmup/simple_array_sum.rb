num = gets.to_i
value = gets.strip.split(" ")[0..num-1].inject(0) do |sum, n|
    sum += n.to_i
end
print value

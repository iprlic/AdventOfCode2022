#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n")
priorities = 0
input.each_slice(3) do |x,y,z|
    only = x.chars.intersection(y.chars).intersection(z.chars).first

    prio = only.ord-64+26
    prio = only.ord - 96 if only.downcase == only

    priorities += prio
end

puts priorities
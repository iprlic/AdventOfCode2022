#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n")

priorities = input.map do |e|
    items = e.chars
    total = items.size

    first = items.take(total / 2)
    second = items.drop(total / 2)

    only = first.intersection(second).first


    prio = only.ord-64+26
    prio = only.ord - 96 if only.downcase == only

    prio
end

puts priorities.sum
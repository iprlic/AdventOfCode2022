#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)


puts(input.split("\n\n").map { |e| e.split("\n").reduce(0){ |sum, n| sum + n.to_i } }.max)

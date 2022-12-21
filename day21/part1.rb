#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

$data = {}

def get_result(mnk)
    monkey = $data[mnk]

    return monkey[:f].to_i if monkey[:op].nil?

    case monkey[:op]
    when "+"
        return get_result(monkey[:f]) + get_result(monkey[:t])
    when "-"
        return get_result(monkey[:f]) - get_result(monkey[:t])
    when "*"
        return get_result(monkey[:f]) * get_result(monkey[:t])
    when "/"
        return get_result(monkey[:f]) / get_result(monkey[:t])
    end
end

input = File.read(file_path).split("\n").each do |line|
    l = line.split(': ')
    op = l[1].split(' ')

    $data[l[0]] = {
        op: op.size>1 ? op[1]: nil,
        f: op[0],
        t: op.size>1 ? op[2]: nil
    }
end

puts get_result("root")

#!/usr/bin/env ruby
# frozen_string_literal: true
require 'json'

def compare(a, b)
    a.each_with_index do |a_item, i|
        b_item = b[i]

        return false if b_item.nil?

        if a_item.is_a? Integer and b_item.is_a? Integer
            return true if a_item < b_item
            return false if a_item > b_item
        end

        if a_item.is_a? Array and b_item.is_a? Array
            com = compare(a_item, b_item)

            return com if !com.nil?
        end

        if a_item.is_a? Array and b_item.is_a? Integer
            com = compare(a_item, [b_item])
            return com if !com.nil?
        end

        if a_item.is_a? Integer and b_item.is_a? Array
            com = compare([a_item], b_item)
            return com if !com.nil?
        end
    end

    return true if a.length < b.length

    return nil
end


def quicksort(arr, first, last)
    if first < last
      p_index = partition(arr, first, last)
      quicksort(arr, first, p_index - 1)
      quicksort(arr, p_index + 1, last)
    end
  
    arr
end

def partition(arr, first, last)
  # first select one element from the list, can be any element. 
  # rearrange the list so all elements less than pivot are left of it, elements greater than pivot are right of it.
  pivot = arr[last]
  p_index = first
  
  i = first
  while i < last
    if compare(arr[i], pivot)
      temp = arr[i]
      arr[i] = arr[p_index]
      arr[p_index] = temp
      p_index += 1
    end
    i += 1
  end
  temp = arr[p_index]
  arr[p_index] = pivot
  arr[last] = temp
  return p_index
end

file_path = File.expand_path('input.txt', __dir__)

packets = File.read(file_path).split("\n\n").map do |packets|
    packets.split("\n").map do |packet|
        JSON.load (packet)
    end
end.flatten(1)

packets.push([[2]])
packets.push([[6]])

ordered = quicksort(packets, 0, packets.length - 1)

puts ordered.each_with_index.reduce(1) { |key, (packet, index)| [[[2]], [[6]]].include?(packet) ? key * (index + 1) : key }

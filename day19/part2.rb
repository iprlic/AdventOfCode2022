#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

$visited = {}
$limit = 32

def check_cache(robots, harvest, minutes)
    key = "#{robots[:ore]},#{robots[:clay]},#{robots[:obsidian]},#{robots[:geode]}-#{minutes}"

    better = false
    if $visited[key].nil?
        $visited[key] = {
            ore: harvest[:ore],
            clay: harvest[:clay],
            obsidian: harvest[:obsidian],
            geode: harvest[:geode]
        }
        better = true
    end

    if $visited[key][:geode] < harvest[:geode]
        $visited[key][:geode] = harvest[:geode]
        better = true
    end

    if $visited[key][:obsidian] < harvest[:obsidian]
        $visited[key][:obsidian] = harvest[:obsidian]
        better = true
    end

    if $visited[key][:clay] < harvest[:clay]
        $visited[key][:clay] = harvest[:clay]
        better = true
    end

    if $visited[key][:ore] < harvest[:ore]
        $visited[key][:ore] = harvest[:ore]
        better = true
    end

    !better
end

def tick(blueprint, robots, harvest, minutes=0, build_ore = false, build_clay = false, build_obsidian = false, build_geode = false)
    minutes += 1

    harvest[:ore] += (robots[:ore])
    harvest[:clay] += (robots[:clay])
    harvest[:obsidian] += (robots[:obsidian])
    harvest[:geode] += (robots[:geode])

    if build_ore
        harvest[:ore] -= blueprint[:ore]
        robots[:ore] += 1
    end

    if build_clay
        harvest[:ore] -= blueprint[:clay]
        robots[:clay] += 1
    end

    if build_obsidian
        harvest[:ore] -= blueprint[:obsidian][0] 
        harvest[:clay] -= blueprint[:obsidian][1] 
        robots[:obsidian] += 1
    end

    if build_geode
        harvest[:ore]  -= blueprint[:geode][0] 
        harvest[:obsidian] -= blueprint[:geode][1] 
        robots[:geode] += 1
    end

    return if check_cache(robots, harvest, minutes)
    return if minutes == $limit

    # either build a robot or not
    can_build_ore_robot = harvest[:ore] >= blueprint[:ore]
    can_build_clay_robot = harvest[:ore] >= blueprint[:clay]
    can_build_obsidian_robot = harvest[:ore] >= blueprint[:obsidian][0] && harvest[:clay] >= blueprint[:obsidian][1]
    can_build_geode_robot = harvest[:ore] >= blueprint[:geode][0] && harvest[:obsidian]  >= blueprint[:geode][1]


    tick(blueprint, robots.dup, harvest.dup, minutes, true, false, false, false) if can_build_ore_robot
    tick(blueprint, robots.dup, harvest.dup, minutes, false, true, false, false) if can_build_clay_robot
    tick(blueprint, robots.dup, harvest.dup, minutes, false, false, true, false) if can_build_obsidian_robot
    tick(blueprint, robots.dup, harvest.dup, minutes, false, false, false, true) if can_build_geode_robot
    tick(blueprint, robots.dup, harvest.dup, minutes, false, false, false, false) 
end

input = File.read(file_path).split("\n").map do |line|
    split = line.split(' ')

    {
        id: split[1].chop.to_i,
        ore: split[6].to_i,
        clay: split[12].to_i,
        obsidian: [
            split[18].to_i,
            split[21].to_i
        ],
        geode: [
            split[27].to_i,
            split[30].to_i
        ]
    }
end.take(3)



total = 1
input.each do |blueprint|
    memo = {
        robots: {
            ore: 1,
            clay: 0,
            obsidian: 0,
            geode: 0
        },
        harvest: {
            ore: 0,
            clay: 0,
            obsidian: 0,
            geode: 0
        }
    }
    $visited = {}

    tick(blueprint, memo[:robots], memo[:harvest])

    result = $visited.values.map{ |v| v[:geode] }.max

    total *= result
end

puts total
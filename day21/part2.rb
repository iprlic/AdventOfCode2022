#!/usr/bin/env ruby
# frozen_string_literal: true
file_path = File.expand_path('input.txt', __dir__)

$data = {}

def get_result(mnk)
    monkey = $data[mnk]

    return nil if mnk == 'humn'

    return monkey[:f].to_i if monkey[:op].nil?


    a = get_result(monkey[:f])
    b = get_result(monkey[:t])

    return nil if a == nil || b == nil

    case monkey[:op]
    when "+"
        return a + b
    when "-"
        return a - b
    when "*"
        return a * b
    when "/"
        return a / b
    end
end
$visited = {}

def get_proper_result(mnk)
    return 0 if mnk == 'root' 
    monkey = $data[mnk]

    if !$visited[mnk].nil?
        puts $visited.keys.join(', ')
        puts mnk
        exit
    end
    $visited[mnk] = true if $visited[mnk].nil?
   
    puts mnk if monkey.nil?
    return monkey[:f].to_i if monkey[:op].nil?

    case monkey[:op]
    when "+"
        return get_proper_result(monkey[:f]) + get_proper_result(monkey[:t])
    when "-"
        return get_proper_result(monkey[:f]) - get_proper_result(monkey[:t])
    when "*"
        return get_proper_result(monkey[:f]) * get_proper_result(monkey[:t])
    when "/"
        return get_proper_result(monkey[:f]) / get_proper_result(monkey[:t])
    end
end

def build_equation(mnk)
    monkey = $data[mnk]

    return 'X' if mnk == 'humn'

    return monkey[:f].to_i if monkey[:op].nil?

    a = build_equation(monkey[:f])
    b = build_equation(monkey[:t])

    return nil if a == nil || b == nil

    return {
        a: a,
        b: b,
        op: monkey[:op]
    }
end


def reverse_equation(mnk, prev_mnk = nil)
    $data.delete(mnk)
    broke = false
    broke_key = '?'
    new_mnk = {}
    $data.each do |k, v|
        next if v[:op].nil?
        if v[:f] == mnk 
            new_op = '?'

            new_op = '-' if v[:op] == '+'
            new_op = '+' if v[:op] == '-'

            new_op = '*' if v[:op] == '/'
            new_op = '/' if v[:op] == '*'
            
            new_mnk = {
                op: new_op,
                f: k,
                t: v[:t]
            }
            broke_key = k
            next if broke_key == prev_mnk
            broke = true
            break
        elsif v[:t] == mnk 
            new_op = '?'

            if v[:op] == '+'
                new_op = '-' 
                new_mnk = {
                    op: new_op,
                    f: k,
                    t: v[:f]
                }    
            end


            if v[:op] == '-'
                new_op = '-' 
                new_mnk = {
                    op: new_op,
                    f: v[:f],
                    t: k
                }    
            end

            if v[:op] == '*'
                new_op = '/' 
                new_mnk = {
                    op: new_op,
                    f: k,
                    t: v[:f]
                }    
            end

            if v[:op] == '/'
                new_op = '/' 
                new_mnk = {
                    op: new_op,
                    f: v[:f],
                    t: k
                }    
            end

       
            broke_key = k

            next if broke_key == prev_mnk
            broke = true
            break
        end
    end

   

    return if !broke

    $data[mnk] = new_mnk 

    reverse_equation(broke_key, mnk)
end

input = File.read(file_path).split("\n").each do |line|
    l = line.split(': ')
    op = l[1].split(' ')

    $data[l[0]] = {
        op: op.size>1 ? op[1]: nil,
        f: l[0] == 'humn' ? 'X' : op[0],
        t: op.size>1 ? op[2]: nil
    }
end


a = get_result($data['root'][:f])
b = get_result($data['root'][:t])

r = a.nil? ? b : a
m = a.nil? ? $data['root'][:f] : $data['root'][:t]
l = a.nil? ? $data['root'][:t] : $data['root'][:f]


reverse_equation('humn')

$data[m] = {
    op: nil,
    f: r.to_s,
    t: nil
}

$data[l] = {
    op: nil,
    f: r.to_s,
    t: nil
}


#$data.each do |k, v|
#    puts "#{k}: #{v[:f]} #{v[:op]} #{v[:t]}"
#end

puts get_proper_result('humn')
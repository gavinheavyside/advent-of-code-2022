#!/usr/bin/env ruby

input = $stdin.readlines.map(&:chomp)

tree = {
  '/' => {name: '/', type: :dir, size: 0, contents: {} }
}

dir_stack = [tree['/']]

input.slice_before(/^\$/).each do |command|
  command_line = command.first
  m = command_line.match(/^\$ (\w+) ?(\S+)?$/)
  if m[1] == 'cd'
    if m[2] == '/'
      dir_stack = [tree['/']]
    elsif m[2] == '..'
      dir_stack.pop
    else
      dir_stack << dir_stack.last[:contents][m[2]]
    end
  elsif m[1] == 'ls'
    command.drop(1).each do |dir_entry|
      metadata, name = dir_entry.split
      if metadata == 'dir'
        dir_stack.last[:contents][name] = {type: :dir, name: name, size: 0, contents: {} }
      else
        dir_stack.last[:contents][name] = {type: :file, name: name, size: metadata.to_i }
      end
    end
  end
end

def cache_dir_sizes(dir)
  size = 0
  dir[:contents].each do |name,meta|
    if meta[:type] == :dir
      size += cache_dir_sizes(meta)
    else
      size += meta[:size]
    end
  end

  dir[:size] = size

  size
end

cache_dir_sizes(tree['/'])


def find_dirs(dir)
  dirs_here = dir[:contents].values.select{|meta| meta[:type] == :dir}
  subdirs = dirs_here.map{ |subdir_meta| find_dirs(subdir_meta) }.flatten

  ([dir] + dirs_here + subdirs).flatten.uniq
end

dirs = find_dirs(tree['/'])

puts dirs.select { |dir| dir[:size] <= 100000 }.map{|dir| dir[:size]}.reduce(:+)


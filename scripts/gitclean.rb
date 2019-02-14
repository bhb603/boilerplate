#!/usr/bin/env ruby

##
# Script for cleaning up stale remote branches.
# Assumes `origin` is the remote repo

MERGED_STALE_AT = 30 # days ago
UNMERGED_STALE_AT = 180 # days ago
DEFAULT_BRANCH = 'master'

class Branch
  attr_reader :name, :author, :time, :days_old

  def self.create_from_branch_name(name)
    name = name.strip.sub(/^origin\//, '')
    timestamp, author = `git show --format="%ct:%an %ae" origin/#{name} | head -n1`.strip.split(':')
    time = Time.at(timestamp.to_i)
    self.new(name, author, time)
  end

  def initialize(name, author, time)
    @name = name
    @author = author
    @time = time
    @days_old = ((Time.now - @time)/(60*60*24)).to_i
  end

  def delete!
    `git push origin :#{@name}`
  end
end

merged = []
unmerged = []

`git branch -r --merged #{DEFAULT_BRANCH} | grep -v HEAD`.split("\n").each do |br|
  merged.push(Branch.create_from_branch_name(br))
end

`git branch -r --no-merged #{DEFAULT_BRANCH} | grep -v HEAD`.split("\n").each do |br|
  unmerged.push(Branch.create_from_branch_name(br))
end

merged_stale = merged
  .select { |branch| branch.days_old >= MERGED_STALE_AT }
  .sort { |a,b| a.time <=> b.time }
unmerged_stale = unmerged
  .select { |branch| branch.days_old >= UNMERGED_STALE_AT }
  .sort { |a,b| a.time <=> b.time }

puts "#{merged_stale.size} branches are merged into #{DEFAULT_BRANCH} and > #{MERGED_STALE_AT} days old:"
merged_stale.each do |branch|
  puts "#{branch.days_old} days old\t#{branch.author}\t#{branch.name}"
end

puts 'Delete all? [y|n]'
if gets.match(/^(y|Y)$/)
  merged_stale.each { |branch| branch.delete! }
  puts "Done"
end

puts "#{unmerged_stale.size} branches are UNMERGED but > #{UNMERGED_STALE_AT} days old:"
unmerged_stale.each do |branch|
  puts "#{branch.days_old} days old\t#{branch.author}\t#{branch.name}"
end

puts 'Delete all? [y|n]'
if gets.match(/^(y|Y)$/)
  unmerged_stale.each { |branch| branch.delete! }
  puts "Done"
end

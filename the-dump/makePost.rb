title = ARGV.join(" ")

if title.empty? then
    puts "You forgot a title!"
    exit 1
end

post = %{---
layout: post
title:  "#{title}"
---

# #{title}

text here
}

today = Time.now
fname = "#{today.year}-#{today.month}-#{today.day}-#{title.gsub(" ", "-")}.md"
fpath = "_posts/#{fname}"

File.open(fpath, "w") do |f|
    f.syswrite post
end

puts "created file at"
puts fpath

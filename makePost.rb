title = ARGV.join(" ")

if title.empty? then
    puts "You forgot a title!"
    exit 1
end

imgs = `ls assets/imgs`.split("\n")
bgimg = imgs[Random::rand(imgs.size)]

post = %{---
layout: post
title:  "#{title}"
background: "/assets/imgs/#{bgimg}"
---

text here
}

today = Time.now
fname = "#{today.year}-#{today.month}-#{today.day}-#{title.gsub(" ", "-")}.md"
fpath = "_posts/#{fname}"

File.open(fpath, "w") do |f|
    f.syswrite post
end

`#{ENV["EDITOR"} #{fpath}`

puts "created file at"
puts fpath

require "./src/blog"

posts = POSTS.sort_by(&.date).reverse

Dir.mkdir_p("public")
posts.each { |post| File.write("public/#{post.slug}.html", post_page(post)) }
File.write("public/index.html", index_page(posts))
File.write("public/about.html", about_page)
puts "Built #{posts.size} posts"
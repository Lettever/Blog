require "../src/site"

@[Post(slug: "numbers", title: "Numbers", date: "2026-10-20", draft: true)]
 def numbers : Safe
  squares = ul((1..5).map { |n| li("#{n}² = #{n * n}") })
  note    = para("Fish ", raw("&amp;"), " chips")

  fragment(
    ("<" if draft?),
    para("Ordinary Crystal works inside a post."),
    sec("Squares", squares),
    sec("Entities", note)
  )
end
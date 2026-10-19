require "../src/site"

@[Post(slug: "hello-world", title: "Hello world", date: "2026-10-19", summary: "My first post")]
def hello_world : Safe
  fragment(
    para("This is my ", em("first"), " post."),
    sec("A list", ul(li("One"), li("Two with a ", a("link", href: "https://example.com")))),
    sec("Some code", pre(code("puts \"hi\"")))
  )
end
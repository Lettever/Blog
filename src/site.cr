require "./html"

macro draft?
  {% a = @def && @def.annotation(Post) %}
  {% if a && a[:draft] %}true{% else %}false{% end %}
end

macro collect_posts
  {% for m in @top_level.methods %}
    {% if a = m.annotation(Post) %}
      SECTIONS.clear
      register({{m.name.id}}(), **{{a.named_args}})
    {% end %}
  {% end %}
end

annotation Post; end

record Section, id : String, title : String
record Page, slug : String, title : String, date : String,
  extra : Hash(String, String), sections : Array(Section), content : Safe

POSTS    = [] of Page
SECTIONS = [] of Section

def slugify(s : String) : String
  s.downcase.gsub(/[^a-z0-9]+/, "-").strip('-')
end

# Bundles several children into one Safe
def fragment(*body) : Safe
  Safe.new(frag(body))
end

# A titled section inside a post; registers itself for the post's TOC
def sec(heading : String, *body) : Safe
  id = slugify(heading)
  SECTIONS << Section.new(id, heading)
  section(h2(heading, id: id), *body)
end

# slug/title/date are required (the compiler enforces it); anything else is metadata
def register(content : Safe, slug : String, title : String, date : String, **extra)
  meta = {} of String => String
  extra.each { |k, v| meta[k.to_s] = v.to_s }
  POSTS << Page.new(slug, title, date, meta, SECTIONS.dup, content)
end

# ---- shared page pieces ----

def site_header : Safe
  header(
    nav(a("My Blog", href: "/"), " | ", a("About", href: "/about.html")),
    class: "site-header"
  )
end

def site_footer : Safe
  footer(para("© #{Time.utc.year}"), class: "site-footer")
end

def toc(sections : Array(Section)) : Safe?
  return nil if sections.empty?
  nav(
    h2("Contents"),
    ol(sections.map { |s| li(a(s.title, href: "##{s.id}")) }),
    class: "toc"
  )
end

def layout(page_title : String, *content) : String
  page(html(
    head(
      meta(charset: "utf-8"),
      meta(name: "viewport", content: "width=device-width, initial-scale=1"),
      title(page_title),
      link(rel: "stylesheet", href: "/style.css")
    ),
    body(site_header, main(*content), site_footer),
    lang: "en"
  ))
end

def post_page(post : Page) : String
  layout(post.title,
    article(
      h1(post.title),
      time(post.date, datetime: post.date),
      toc(post.sections),
      post.content
    )
  )
end

def index_page(posts : Array(Page)) : String
  layout("My Blog",
    h1("Posts"),
    ul(posts.map { |post|
      li(
        a(post.title, href: "/#{post.slug}.html"), " ",
        span(post.date, class: "date"),
        para(post.extra["summary"]?)
      )
    })
  )
end

def about_page : String
  layout("About",
    h1("About"),
    para("A blog written entirely as function calls.")
  )
end
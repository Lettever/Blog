require "html"

# Marks a string as already-safe HTML (not escaped again).
struct Safe
  getter value : String
  def initialize(@value : String); end
end

# Wrap trusted HTML (entities, inline SVG, embeds). Never pass user input.
def raw(s : String) : Safe
  Safe.new(s)
end

# Turn any child into a string: Safe passes through, text is escaped,
# arrays/tuples are flattened recursively, nil renders nothing.
def frag(x : Safe) : String;   x.value;         end
def frag(x : String) : String; HTML.escape(x);  end
def frag(x : Number) : String; x.to_s;          end
def frag(x : Nil) : String;    "";              end
def frag(xs : Array | Tuple) : String
  xs.join { |x| frag(x) }
end

def attr_str(attrs) : String
  attrs.map { |k, v| %( #{k}="#{HTML.escape(v.to_s)}") }.join
end

def tag(name : String, body, attrs) : Safe
  Safe.new("<#{name}#{attr_str(attrs)}>#{frag(body)}</#{name}>")
end

# Normal tags: name(*children, **attributes)
{% for name in %w(html head body header nav main article section aside footer
                  h1 h2 h3 h4 h5 h6 ul ol li a div span time title
                  em strong small code pre blockquote figure figcaption
                  table thead tbody tr th td button label
                  script style) %}
  def {{name.id}}(*body, **attrs) : Safe
    tag({{name}}, body, attrs)
  end
{% end %}

# `p` collides with Kernel#p, so the paragraph helper is `para`
def para(*body, **attrs) : Safe
  tag("p", body, attrs)
end

# Void elements: attributes only, no body, no closing tag
{% for name in %w(meta link img br hr input) %}
  def {{name.id}}(**attrs) : Safe
    Safe.new("<{{name.id}}#{attr_str(attrs)}>")
  end
{% end %}

# Full document with doctype
def page(root : Safe) : String
  "<!DOCTYPE html>\n" + root.value
end
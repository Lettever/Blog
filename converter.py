import markdown2

with open('example.md', 'r') as f:
    text = f.read()

html = markdown2.markdown(
    text,
    extras=[
        "tables", "cuddled-lists",
        "break-on-newline", "task_list",
        "metadata", "fenced-code-blocks",
        "smarty-pants", "tag-friendly",
        "markdown-in-html"
    ]
)
print(html.metadata)

with open('output.html', 'w') as f:
    f.write(html)
; extends

("text" @text.todo
 (#eq? @text.todo "TODO"))

((tag
  (name) @text.todo)
  (#eq? @text.todo "TODO"))

("text" @text.danger
 (#any-of? @text.danger "SAFETY"))

((tag
  (name) @comment.safety
  ":" @comment.delimiter)
  (#eq? @comment.safety "SAFETY"))

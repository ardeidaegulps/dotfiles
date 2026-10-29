; extends

"?" @exception.operator
"::" @namespace
"const" @keyword

(mutable_specifier) @type.qualifier

(lifetime
  "'" @label
  (identifier) @label)

(lifetime
  "'" @label.builtin
  (identifier) @label.builtin.name
  (#eq? @label.builtin.name "static"))

(attribute_item
  ["#" "[" "]"] @attribute
  (_
    (identifier) @attribute
    arguments: (_ ["(" ")"] @attribute) @attribute))

(scoped_identifier
  path: (identifier) @namespace.scoped)

(scoped_type_identifier
  path: (identifier) @namespace.scoped)

(visibility_modifier
  "(" @namespace
  [(crate) (super) (self)] @keyword
  ")" @namespace)

; (macro_invocation
;   macro: (identifier) @function.macro
;   "!" @function.macro)

(macro_invocation
  macro: (identifier) @debug
  "!" @debug.delimiter
  _ @function.call
  (#eq? @debug "dbg")) @debug

(self) @self

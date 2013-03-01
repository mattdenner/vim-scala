if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case match
syn sync minlines=50

syn keyword scalaKeyword package
syn keyword scalaKeyword import
syn keyword scalaKeyword class
syn keyword scalaKeyword abstract class
syn keyword scalaKeyword case class
syn keyword scalaKeyword trait
syn keyword scalaKeyword object
syn keyword scalaKeyword type
syn keyword scalaKeyword sealed
syn keyword scalaKeyword final
syn keyword scalaKeyword new
syn keyword scalaKeyword def nextgroup=scalaMethod skipwhite
syn keyword scalaKeyword for
syn keyword scalaKeyword match
syn keyword scalaKeyword case
syn keyword scalaKeyword _
syn keyword scalaKeyword val nextgroup=scalaValue skipwhite
syn keyword scalaKeyword if
syn keyword scalaKeyword else
syn keyword scalaKeyword yield
syn keyword scalaKeyword implicit
syn keyword scalaKeyword implicitly
syn keyword scalaKeyword extends
syn keyword scalaKeyword with

syn keyword scalaKeyword private
syn keyword scalaKeyword this
syn keyword scalaKeyword super
syn keyword scalaKeyword override
syn keyword scalaKeyword lazy

syn keyword scalaBadKeyword var
syn keyword scalaBadKeyword null

syn keyword scalaBoolean true
syn keyword scalaBoolean false

syn match scalaKeyword "\(=>\|->\|<-::\)"

syn match scalaType "\W\zs[A-Z][A-Za-z0-9]*" nextgroup=scalaGenerics
syn region scalaGenerics start="\[" end="\]" contains=scalaAnonymousType,scalaTypeVariance,scalaType
syn region scalaAnonymousType start="({" end="})" nextgroup=scalaRef
syn match scalaRef "#" contained nextgroup=scalaTypeVariant
syn match scalaTypeVariance "[+-]" contained nextgroup=scalaTypeVariant
syn match scalaTypeVariance "<:\|>:\|:" contained nextgroup=scalaTypeVariant
syn match scalaTypeVariant "[A-Z][A-Za-z0-9]*" contained
syn match scalaParameter "[a-z][A-Za-z0-9]*\(:\)\@="
syn match scalaValue "[A-Za-z][A-Za-z0-9]*" contained

syn match scalaMethod "[A-Za-z][A-Za-z0-9]*" contained

syn match scalaComment "//.*"
syn region scalaComment start="/\*" end="\*/"

syn match scalaString '""'
syn region scalaString start=*"[^"]* skip=*\\"* end=*"*
syn region scalaString start=*"""* end=*"""*
syn region scalaCharacter start="'" skip="\\'" end="'"

hi link scalaKeyword Keyword
hi link scalaBadKeyword Error
hi link scalaBoolean Boolean
hi link scalaType Type
hi link scalaTypeVariance scalaKeyword
hi link scalaTypeVariant scalaType
hi link scalaParameter Constant
hi link scalaValue Constant
hi link scalaComment Comment
hi link scalaString String
hi link scalaCharacter String
hi link scalaMethod Function
hi link scalaRef Keyword

syn sync fromstart

"" Enable the syntax highlight as scala
let b:current_syntax = "scala"

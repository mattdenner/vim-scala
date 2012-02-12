if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case match
syn sync minlines=50

"" Syntax for package and import
syn keyword scalaPackage               package                                                     nextgroup=scalaFullyQualifiedPackage                             skipwhite
syn keyword scalaImport                import                                                      nextgroup=scalaFullyQualifiedPackage,scalaFullyQualifiedImport   skipwhite
syn match   scalaFullyQualifiedPackage "[a-z][a-z0-9]*\(.[a-z][a-z0-9]*\)\+"             contained                                                                  skipwhite
syn match   scalaFullyQualifiedImport  "[A-Za-z][A-Za-z0-9]*\(.[A-Za-z][A-Za-z0-9]*\)\+" contained nextgroup=scalaImportClass,scalaImportEverything,scalaMapImports skipwhite
syn region  scalaMapImports            start="\.{" end="}"                                         contains=scalaMethodName,scalaClassName,scalaMap,scalaConstant   skipwhite
syn match   scalaImportClass           "\.\([A-Z][a-z0-9]*\)\+"                          contained
syn match   scalaImportEverything      "\._"                                             contained
syn match   scalaMap                   "=>"                                              contained

hi link scalaPackage               Include
hi link scalaImport                Include
hi link scalaFullyQualifiedPackage Identifier
hi link scalaFullyQualifiedImport  Identifier
hi link scalaImportClass           Identifier
hi link scalaImportEverything      Identifier
hi link scalaMapImports            Identifier
hi link scalaMap                   Keyword

"" Syntax for class, object and traits
syn keyword scalaClass            class                                      nextgroup=scalaClassName        skipwhite
syn keyword scalaObject           object                                     nextgroup=scalaClassName        skipwhite
syn keyword scalaTrait            trait                                      nextgroup=scalaClassName        skipwhite
syn keyword scalaExtend           extends                                    nextgroup=scalaClassName        skipwhite
syn match   scalaClassName        "[^\s\.a-z]\zs\([A-Z][a-z]*\)\+"           nextgroup=scalaClassSpecializer skipwhite
syn region  scalaClassSpecializer start="\[" end="\]"              contained contains=scalaClassName

hi link scalaClass            Keyword
hi link scalaObject           Keyword
hi link scalaTrait            Keyword
hi link scalaExtend           Keyword
hi link scalaClassName        Type
hi link scalaClassSpecializer Normal

"" Syntax for functions, variables & values.
syn keyword scalaMethodDefinition       def                                                nextgroup=scalaMethodName                 skipwhite
syn keyword scalaVariableDefinition     var                                                nextgroup=scalaVariableName               skipwhite
syn keyword scalaValueDefinition        val                                                nextgroup=scalaValueName                  skipwhite
syn match   scalaMethodName             "\([a-z][A-Za-z_]*\|[+*/-]\)"            contained nextgroup=scalaMethodParamsDefinition     skipwhite
syn match   scalaVariableName           "[a-z][A-Za-z]*\(_[A-Za-z]\)\?"          contained
syn match   scalaValueName              "[a-z][A-Za-z]*\(_[A-Za-z]\)\?"          contained
syn match   scalaMethodParamsDefinition "([^:]\+:[^,\)]\+\(,[^:]\+:[^,\)]\+\)*)" contained contains=scalaClassName,scalaVariableName skipwhite
syn match   scalaAnonymousValue         "_\*\?"
syn match   scalaSymbol                 "'[a-z][A-Za-z_]*\(\s\)\@="

hi link scalaMethodDefinition       Keyword
hi link scalaMethodName             Function
hi link scalaVariableDefinition     Keyword
hi link scalaVariableName           Identifier
hi link scalaValueName              Constant
hi link scalaValueDefinition        Keyword
hi link scalaMethodParamsDefinition Normal
hi link scalaAnonymousValue         Constant
hi link scalaSymbol                 Constant

"" Syntax for keywords
syn keyword scalaConditional if
syn keyword scalaConditional else
syn keyword scalaConditional match
syn keyword scalaConditional case
syn keyword scalaRepeat      for
syn keyword scalaRepeat      forSome
syn keyword scalaRepeat      do
syn keyword scalaRepeat      while
syn keyword scalaKeyword     new
syn keyword scalaKeyword     with
syn keyword scalaKeyword     this
syn keyword scalaValidation  require
syn keyword scalaValidation  assert
syn keyword scalaRange       to
syn keyword scalaRange       until

hi link scalaConditional Conditional
hi link scalaRepeat      Repeat
hi link scalaKeyword     Keyword
hi link scalaValidation  Keyword
hi link scalaRange       Keyword

"" Syntax for modifiers
syn keyword scalaKeywordModifier abstract
syn keyword scalaKeywordModifier override
syn keyword scalaKeywordModifier final
syn keyword scalaKeywordModifier implicit
syn keyword scalaKeywordModifier lazy
syn keyword scalaKeywordModifier private
syn keyword scalaKeywordModifier protected
syn keyword scalaKeywordModifier sealed
syn match   scalaKeywordModifier "@unchecked"

hi link scalaKeywordModifier Keyword

"" Syntax for strings
syn match  scalaEmptyString     *""*
syn region scalaString          start=*"[^"]* skip=*\\"* end=*"*       contains=scalaStringEscape
syn region scalaMultiLineString start=*"""*              end=*""""\@!* contains=scalaUnicode
syn region scalaCharacter       start="'"     skip="\\'" end="'"       contains=scalaStringEscape
syn match  scalaUnicode         "\\u[0-9a-fA-F]\{4}" contained
syn match  scalaStringEscape    "\\u[0-9a-fA-F]\{4}" contained
syn match  scalaStringEscape    "\\[nrfvb\\\"]"      contained

hi link scalaEmptyString     String
hi link scalaString          String
hi link scalaMultiLineString String
hi link scalaCharacter       String

"" Comments
syn match   scalaLineComment      "//.*"                contains=scalaTodo
syn region  scalaMultiLineComment start="/\*" end="\*/" contains=scalaTodo
syn keyword scalaTodo             TODO                  contained
syn keyword scalaTodo             FIXME                 contained
syn keyword scalaTodo             NOTE                  contained

hi link scalaTodo             Todo
hi link scalaLineComment      Comment
hi link scalaMultiLineComment Comment

"" Constants, of various types because Scala has several things that appear to
"" be constants.
syn match   scalaConstant    "[A-Z][A-Z0-9_]\+\([A-Za-z]\)\@!"
syn keyword scalaConstant    Nil
syn keyword scalaConstant    Null
syn keyword scalaConstant    Symbol
syn keyword scalaConstant    Unit
syn keyword scalaConstant    Nothing
syn keyword scalaConstant    Any
syn keyword scalaConstant    AnyRef
syn keyword scalaConstant    AnyVal
syn match   scalaConstant    "\(^\|\s\)\zs()"

hi link scalaConstant   Constant

"" Some miscellaneous stuff
syn match   scalaOperator    "\s\zs\(&&\?\|||\?\|[+*/-]=\|<<\|>>>\?\|[=+*/%-]\)\(\s\)\@="
syn match   scalaOperator    ":\{2,3}\(\s\)\@="
syn match   scalaOperator    "!\|\~"
syn match   scalaOperator    "\s\zs\(++\|##\)\(\s\)\@="
syn match   scalaComparator  "\s\zs\(==\|!=\|<=\?\|>=\?\)\(\s\)\@="
syn match   scalaNumber      "\(0x\x\+\|0\o\+\|0[lL]\?\|\(\<\|-\)[1-9]\d*[lL]\?\)"
syn match   scalaFloat       "-\?\d\+\.\d\+"
syn match   scalaArrow       "\s\zs\(<-\|=>\)\(\s\)\@="
syn match   scalaAttributed  "@[^\s]+"
syn keyword scalaBoolean     true
syn keyword scalaBoolean     false
syn keyword scalaException   try
syn keyword scalaException   catch
syn keyword scalaException   finally
syn keyword scalaException   throw

hi link scalaArrow      Keyword
hi link scalaOperator   Operator
hi link scalaComparator Operator
hi link scalaBoolean    Boolean
hi link scalaNumber     Number
hi link scalaFloat      Float
hi link scalaException  Exception
hi link scalaAttributed PreProc

"" Catch some things that are illegal in Scala and that I'm likely to type
"" frequently, coming from Java & Ruby and being slightly dumb sometimes!
syn match scalaIllegal  "[a-z]\zs\(+\{2,}\|-\{2,}\)"      " i++ & i-- are illegal
syn match scalaIllegal  "\(+\{2,}\|-\{2,}\)\([a-z]\)\@="  " ++i & --i are illegal
syn match scalaIllegal  ":\{2,3}\s*$"                     " ending line with '::' or '::'
syn match scalaIllegal  "'[^\s']\{2,}'"                   " 'string' is illegal
syn match scalaIllegal  "0\(\o*[89]\o*\)\+"               " invalid octal number
syn match scalaIllegal  "_:"                              " causes compiler error (needs whitespace!)
syn match scalaIllegal  "ex:"                             " causes VIM error on syntax highlighting!

hi link scalaIllegal    Error

syn sync fromstart

"" Enable the syntax highlight as scala
let b:current_syntax = "scala"

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case match
syn sync minlines=50

"" Syntax for package and import
syn keyword scalaPackage               package                                         nextgroup=scalaFullyQualifiedPackage                             skipwhite
syn keyword scalaImport                import                                          nextgroup=scalaFullyQualifiedPackage,scalaFullyQualifiedImport   skipwhite
syn match   scalaFullyQualifiedPackage "[a-z][a-z0-9]*\(.[a-z][a-z0-9]*\)\+" contained                                                                  skipwhite
syn match   scalaFullyQualifiedImport  "[a-z][a-z0-9]*\(.[a-z][a-z0-9]*\)\+" contained nextgroup=scalaImportClass,scalaImportEverything,scalaMapImports skipwhite
syn region  scalaMapImports            start="\.{" end="}"                             contains=scalaClassName,scalaMap                                 skipwhite
syn match   scalaImportClass           "\.[A-Z][a-z]*"                       contained
syn match   scalaImportEverything      "\._"                                 contained
syn match   scalaMap                   "=>"                                  contained

hi link scalaPackage               Include
hi link scalaImport                Include
hi link scalaFullyQualifiedPackage Identifier
hi link scalaFullyQualifiedImport  Identifier
hi link scalaImportClass           Identifier
hi link scalaImportEverything      Identifier
hi link scalaMapImports            Identifier
hi link scalaMap                   Keyword

"" Syntax for class, object and traits
syn keyword scalaClass            class                         nextgroup=scalaClassName        skipwhite
syn keyword scalaObject           object                        nextgroup=scalaClassName        skipwhite
syn keyword scalaTrait            trait                         nextgroup=scalaClassName        skipwhite
syn keyword scalaExtend           extends                       nextgroup=scalaClassName        skipwhite
syn match   scalaClassName        "\([A-Z][a-z]*\)\+" contained nextgroup=scalaClassSpecializer skipwhite
syn region  scalaClassSpecializer start="\[" end="\]" contained contains=scalaClassName

hi link scalaClass            Keyword
hi link scalaObject           Keyword
hi link scalaTrait            Keyword
hi link scalaExtend           Keyword
hi link scalaClassName        Type
hi link scalaClassSpecializer Normal

"" Syntax for functions & variables
syn keyword scalaMethodDefinition       def                                      nextgroup=scalaMethodName                 skipwhite
syn keyword scalaVariableDefinition     var                                      nextgroup=scalaVariableName               skipwhite
syn keyword scalaValueDefinition        val                                      nextgroup=scalaVariableName               skipwhite
syn match   scalaMethodName             "[a-z][A-Za-z_]*"                        contained
syn match   scalaVariableName           "[a-z][A-Za-z_]*"                        contained
syn match   scalaMethodParamsDefinition "([^:]\+:[^,\)]\+\(,[^:]\+:[^,\)]\+\)*)" contains=scalaClassName,scalaVariableName skipwhite

hi link scalaMethodDefinition       Keyword
hi link scalaMethodName             Function
hi link scalaVariableDefinition     Keyword
hi link scalaVariableName           Identifier
hi link scalaValueDefinition        Keyword
hi link scalaMethodParamsDefinition Normal

"" Syntax for keywords
syn keyword scalaConditional if
syn keyword scalaConditional else
syn keyword scalaConditional match
syn keyword scalaConditional case
syn keyword scalaRepeat      for
syn keyword scalaRepeat      forSome
syn keyword scalaRepeat      do
syn keyword scalaRepeat      while

hi link scalaConditional Conditional
hi link scalaRepeat      Repeat

"" Syntax for modifiers
syn keyword scalaKeywordModifier abstract
syn keyword scalaKeywordModifier override
syn keyword scalaKeywordModifier final
syn keyword scalaKeywordModifier implicit
syn keyword scalaKeywordModifier lazy
syn keyword scalaKeywordModifier private
syn keyword scalaKeywordModifier protected
syn keyword scalaKeywordModifier sealed

hi link scalaKeywordModifier Keyword

"" Syntax for strings
syn match  scalaEmptyString     "\"\""
syn region scalaString          start="\"[^"]" skip="\\\"" end="\""          contains=scalaStringEscape
syn region scalaMultiLineString start="\"\"\""             end="\"\"\"\"\@!" contains=scalaUnicode
syn match  scalaUnicode         "\\u[0-9a-fA-F]\{4}" contained
syn match  scalaStringEscape    "\\u[0-9a-fA-F]\{4}" contained
syn match  scalaStringEscape    "\\[nrfvb\\\"]"      contained

hi link scalaEmptyString     String
hi link scalaString          String
hi link scalaMultiLineString String

"" Comments
syn match  scalaTodo             "\(TODO\|FIXME\)"     contained
syn match  scalaLineComment      "//.*"                contains=scalaTodo
syn region scalaMultiLineComment start="/\*" end="\*/" contains=scalaTodo

hi link scalaTodo             Todo
hi link scalaLineComment      Comment
hi link scalaMultiLineComment Comment

"" Some miscellaneous stuff
syn match scalaOperator   "\(&&\?\|||\?\|==\?\|++\?\|--\?\)"
syn match scalaBoolean    "\(true\|false\)"
syn match scalaNumber     "\(0x\x\+\|0\o\+\|\(\<\|-\)[1-9]\d*\)"
syn match scalaFloat      "-\?\d\+\.\d\+"
syn match scalaArrow      "=>"
syn match scalaAttributed "@[^\s]+"
syn keyword scalaException try
syn keyword scalaException catch
syn keyword scalaException finally
syn keyword scalaException throw

hi link scalaArrow      Keyword
hi link scalaOperator   Operator
hi link scalaBoolean    Boolean
hi link scalaNumber     Number
hi link scalaFloat      Float
hi link scalaException  Exception
hi link scalaAttributed PreProc

syn sync fromstart

"" Enable the syntax highlight as scala
let b:current_syntax = "scala"

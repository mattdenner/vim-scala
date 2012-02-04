"" Scala indentation code.
""
"" This is based on the Scala code I've seen, not written, nor on the language
"" specification, so it might be complete crap!  It does, however, format
"" things in a manner I like so far.  It doesn't cover everything but should
"" capture the main points.
""
"" TODO:
"" * 'while' & 'do..while' loops
""
setlocal indentexpr=ScalaIndent()
setlocal indentkeys=0{,0},0),!^F,<>>,o,O,e,=case,<CR>
setlocal autoindent

"" Calculates the indent based on the previous non-blank line and the current
"" line when looking for parentheses.
function! scala#indentBasedOn(prevlnum, curlnum, openparen, closeparen)
  let indent = 0
  let previousline = getline(a:prevlnum)
  let currentline = getline(a:curlnum)

  let previousopen = match(previousline, a:openparen)
  if previousopen != -1
    let previousclose = match(previousline, a:closeparen)
    if previousclose == -1 || previousopen > previousclose
      let indent = indent + &shiftwidth
    endif
  endif

  let currentclose = match(currentline, a:closeparen)
  if currentclose != -1
    let currentopen = match(currentline, a:openparen)
    if currentopen == -1 || currentopen > currentclose
      let indent = indent - &shiftwidth
    endif
  endif

  return indent
endfunction

function! ScalaIndent()
  "" If we're at the top of the file then the indent is automatically 0
  let prevlnum = prevnonblank(v:lnum - 1)
  if prevlnum == 0
    return 0
  endif

  let indent = indent(prevlnum)
  let previousline = getline(prevlnum)

  "" Indent based on the block markers, which can be either code blocks,
  "" parameters, or lists.
  let indent = indent + scala#indentBasedOn(prevlnum, v:lnum, '{', '}')
  let indent = indent + scala#indentBasedOn(prevlnum, v:lnum, '(', ')')
  let indent = indent + scala#indentBasedOn(prevlnum, v:lnum, '[', ']')

  "" If the previous line starts a multiline comment then the indent is one.
  "" If it's a continuation of the multiline comment then the indent remains
  "" the same.  If the previous line is the end of a multiline comment then
  "" reduce the indent by one.
  let commentstart = match(previousline, '/\*')
  let commentend   = match(previousline, '\*/')
  if commentstart != -1
    let indent = indent + 1
  end
  if commentend != -1
    let indent = indent - 1
  endif
  if commentstart != -1 || commentend != -1
    return indent
  endif

  "" If we're closing a block then look to find the opening.  The indent is
  "" then the same as the opening.
  let closebracepos = match(getline(v:lnum), '}')
  if closebracepos != -1
    call cursor(v:lnum, closebracepos+1) " Position on the brace for correct matching
    let matchline = searchpair('{', '', '}', 'bW')
    if matchline > 0
      return indent(matchline)
    endif
  endif

  "" Indentation for case is a little awkward!  Essentially 'case' is aligned
  "" with each 'case', but indented by shiftwidth from the 'match'.  The hard
  "" bit is to get the correct indentation level for the close of the 'match',
  "" but searchpair to the rescue!
  let previouscase = match(previousline, '^\s\+case\s')
  let currentcase  = match(getline(v:lnum), '^\s\+case\s')
  if previouscase != -1 && currentcase != -1
    return indent       " case followed by case means no indentation change
  elseif previouscase != -1 && match(previousline, '=>\s*$') != -1
    let indent = indent + &shiftwidth
  elseif currentcase != -1 && match(previousline, '\s\(match\s*{\|}\)') == -1
    return indent - &shiftwidth
  endif

  "" Single line looping.  Nothing complicated as it assumes that people
  "" aren't stupid enough to make a multiline single line loop without braces!
  "" Nested loops should work, but don't count on it, especially for mixed
  "" single & multiline loops!
  let loopmatch = '^\s*\(for\|while\|if\)\s*([^{]\+$'
  if match(getline(v:lnum-1), loopmatch) != -1
    return indent + &shiftwidth
  elseif match(getline(v:lnum-1), '^\s*else\s*$') != -1
    return indent + &shiftwidth
  else
    let loopline = prevnonblank(v:lnum - 1)
    while match(getline(loopline-1), loopmatch) != -1
      let indent = indent(loopline-1)
      let loopline = loopline - 1
    endwhile
  endif

  "" Ok, so maybe we're part of an assignment: either the value being
  "" assigned or following one.  The following one can come after a block, so
  "" we need to account for that too.
  let assignmentlnum = prevlnum
  let assignmentline = previousline
  let matcher = "=\s*$"
  " \(\s*else\|=\)\s*$"

  let closebracepos = match(assignmentline, '}')
  if closebracepos != -1
    call cursor(assignmentlnum, closebracepos+1) " Position on the brace for correct matching
    let matchline = searchpair('{', '', '}', 'bW')
    if matchline > 0 && match(getline(matchline-1), matcher) != -1
      let assignmentlnum = matchline
      let assignmentline = getline(assignmentlnum)
    endif
  endif
  if match(assignmentline, matcher) != -1
    return indent + &shiftwidth
  elseif match(getline(assignmentlnum-1), matcher) != -1
    return indent(assignmentlnum-1)
  endif


  return indent
endfunction

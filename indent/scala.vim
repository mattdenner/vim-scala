"" Scala indentation code.
""
"" This is based on the Scala code I've seen, not written, nor on the language
"" specification, so it might be complete crap!  It does, however, format
"" things in a manner I like so far.  It doesn't cover everything but should
"" capture the main points.
""
"" FIX:
"" * open '(' and close ')' don't appear to be lining up correctly
""
setlocal indentexpr=ScalaIndent()
setlocal indentkeys=0{,0},0),!^F,<>>,o,O,e,=case,<CR>
setlocal autoindent

function! scala#bracketIndent(lnum, openparen, closeparen)
  let currentline = getline(a:lnum)
  let currentopens  = strlen(currentline)-strlen(substitute(currentline, a:openparen, "", "g"))
  let currentcloses = strlen(currentline)-strlen(substitute(currentline, a:closeparen, "", "g"))
  return currentopens - currentcloses
endfunction

function! scala#countedBracketIndent(prevlnum, curlnum, openparen, closeparen)
  let indent = scala#bracketIndent(a:prevlnum, a:openparen, a:closeparen)
  let currentIndent = scala#bracketIndent(a:curlnum, a:openparen, a:closeparen)
  if currentIndent < 0
    let indent = indent + currentIndent
  endif
  return indent
endfunction

function! scala#uncountedBracketIndent(prevlnum, curlnum, openparen, closeparen)
  let indent = 0
  let balance = scala#bracketIndent(a:prevlnum, a:openparen, a:closeparen)
  if balance > 0
    let indent = indent + 1
  elseif balance < 0
    let indent = indent - 1
  end

  let balance = scala#bracketIndent(a:curlnum,  a:openparen, a:closeparen)
  if balance > 0
    let indent = indent + 1
  elseif balance < 0
    let indent = indent - 1
  end
  return indent
endfunction

function! scala#internalIndent(prevlnum, previousline)
  "" If we're closing a block then look to find the opening.  The indent is then the same
  "" as the opening.
  let closebracepos = match(getline(v:lnum), '}')
  if closebracepos != -1
    call cursor(v:lnum, closebracepos+1) " Position on the brace for correct matching
    let matchline = searchpair('{', '', '}', 'bW')
    if matchline > 0
      return indent(matchline) / &shiftwidth
    endif
  endif

  "" Readjust the previous line if we're preceeded by a close of a block.
  let closebracepos = match(a:previousline, "}\s*$")
  if closebracepos != -1
    call cursor(a:prevlnum, closebracepos+1)
    let matchline = searchpair('{', '', '}', 'bW')
    if matchline > 0
      return indent(matchline) / &shiftwidth
    endif
  endif

  let previousIndent = indent(a:prevlnum) / &shiftwidth
  let indent = previousIndent

  "" Indent based on the block markers, which can be either code blocks, parameters, or lists.
  let indent = indent + scala#uncountedBracketIndent(a:prevlnum, v:lnum, '(', ')')
  let indent = indent + scala#uncountedBracketIndent(a:prevlnum, v:lnum, '[', ']')
  let indent = indent + scala#countedBracketIndent(a:prevlnum, v:lnum, '{', '}')

  "" Match works as a block, but cases are levelly indented within it.
  if match(getline(v:lnum), '^\s*case\s\(class\)\@!') != -1
    if match(a:previousline, '\smatch\s*{') != -1
      return previousIndent + 1
    elseif match(a:previousline, '^\s*case\s\(class\)\@!') != -1
      return previousIndent
    endif
  elseif match(a:previousline, '=>\s*$') != -1
    let indent = indent + 1
  endif

  "" Single line looping.  Nothing complicated as it assumes that people
  "" aren't stupid enough to make a multiline single line loop without braces!
  "" Nested loops should work, but don't count on it, especially for mixed
  "" single & multiline loops!
  let loopmatch = '^\s*\(for\|while\|if\)\s*([^{]\+$'
  if match(getline(v:lnum-1), loopmatch) != -1
    return indent + 1
  elseif match(getline(v:lnum-1), '^\s*else\s*$') != -1
    return indent + 1
  else
    let loopline = prevnonblank(v:lnum - 1)
    while match(getline(loopline-1), loopmatch) != -1
      let indent = indent(loopline-1) / &shiftwidth
      let loopline = loopline - 1
    endwhile
  endif

  "" If the previous line is an assignment we indent.
  if match(a:previousline, "=\s*$") != -1
    return indent + 1
  elseif match(getline(a:prevlnum-1), "=\s*$") != -1
    return indent(a:prevlnum-1) / &shiftwidth
  endif

  return indent
endfunction

function! ScalaIndent()
  "" If we're at the top of the file then the indent is automatically 0
  let prevlnum = prevnonblank(v:lnum - 1)
  if prevlnum == 0
    return 0
  endif

  let previousline = getline(prevlnum)
  let indent = indent(prevlnum)

  "" Handle comments.  Either a single line comment, or the middle/end of a multiline comment,
  "" or we are just inside/after the start/end of a multiline comment.
  if match(previousline, '//') != -1
    return indent
  elseif match(getline(v:lnum), '\(^\s*\*\|\*/\)') != -1
    let matchline = searchpair('/\*', '', '\*/', 'bW')
    if matchline > 0
      return indent(matchline-1) + 1
    endif
  else
    let commentstart = match(previousline, '/\*')
    let commentend   = match(previousline, '\*/')
    if commentstart != -1
      let indent = indent + 1
    endif
    if commentend != -1
      let indent = indent - 1
    endif
    if commentstart != -1 || commentend != -1
      return indent
    endif
  endif
  return scala#internalIndent(prevlnum, previousline) * &shiftwidth
endfunction

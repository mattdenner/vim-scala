if exists('g:loaded_scala_md') || &cp
  finish
endif
let g:loaded_scala_md=1

"" Number of vimux windows open
let g:scalaVimuxWindowOpen=0
let g:scalaVimuxOpening=0

"" Opens the companion file in an appropriate split.
function! scala#openCompanionFile(name)
  let handler = [ function("scala#".a:name."Mapper"), function("scala#".a:name."Open") ]

  let filename = handler[0](bufname('%'))
  if filename == bufname('%')
    return
  elseif bufnr(filename) == -1
    if filereadable(filename)
      let x = handler[1]('split', filename)
    else
      let x = handler[1]('new', filename)
    endif
  else
    "" Buffer already exists!
  endif
endfunction

function! scala#companionOfSourceMapper(sourceFilename)
  return substitute(substitute(a:sourceFilename, 'main', 'test', ''), '\.scala', 'Test.scala', '')
endfunction
function! scala#companionOfSourceOpen(action, testFilename)
  exec 'botright' 'v'.a:action a:testFilename
endfunction

function! scala#companionOfTestMapper(testFilename)
  return substitute(substitute(a:testFilename, 'test', 'main', ''), 'Test\.scala', '.scala', '')
endfunction
function! scala#companionOfTestOpen(action, sourceFilename)
  exec 'topleft' 'v'.a:action a:sourceFilename
endfunction

function! scala#executeInSbt() range
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines         = getline(lnum1, lnum2)
  let lines[-1]     = lines[-1][: col2 - 2]
  let lines[0]      = lines[0][col1 - 1:]
  call VimuxRunCommand(":paste\n".join(lines, "\n")."\n\04", 0)
endfunction

"" Ensure that the filetype is correctly identified (duplicated in ftdetect/scala.vim)
autocmd BufNewFile,BufRead *.scala                 set filetype=scala
autocmd BufNewFile,BufRead *Spec.scala,*Test.scala set filetype=scalatest syntax=scala
autocmd BufNewFile,BufRead *.sbt                   set filetype=scala

"" Setup some leader mappings so that we can drive SBT easily
autocmd FileType scala,scalatest nmap <leader>ss :call VimuxRunCommand('sbt')<cr>
autocmd FileType scala,scalatest nmap <leader>ssc <leader>ss<leader>sc
autocmd FileType scala,scalatest nmap <leader>sC :call VimuxCloseRunner()<cr>
autocmd FileType scala,scalatest nmap <leader>st :call VimuxRunCommand('test')<cr>
autocmd FileType scala,scalatest nmap <leader>sc :call VimuxRunCommand('console')<cr>
autocmd FileType scala,scalatest vmap <leader>se :call scala#executeInSbt()<cr>
autocmd FileType scala           nmap <leader>sp :call scala#openCompanionFile('companionOfSource')<cr>
autocmd FileType scalatest       nmap <leader>sp :call scala#openCompanionFile('companionOfTest')<cr>

"" Ensure that snipMate support is configured, which doesn't require the
"" plugin to actually be installed.
if !exists('g:snipMate')
  let g:snipMate = {}
endif
if !get(g:snipMate, 'scope_aliases')
  let g:snipMate.scope_aliases = {}
endif
let g:snipMate.scope_aliases['scalatest'] = 'scala,scalatest'

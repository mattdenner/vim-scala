if exists("g:loaded_scala_md") || &cp
  finish
endif
let g:loaded_scala_md=1

"" Number of vimux windows open
let g:scalaVimuxWindowOpen=0

"" Opens a vimux terminal with 'sbt' running in it.
function! scala#open()
  if (g:scalaVimuxWindowOpen == 0)
    call VimuxRunCommand('sbt')
  endif
  let g:scalaVimuxWindowOpen=g:scalaVimuxWindowOpen+1
endfunction

"" Closes the vimux terminal if there are no more scala files open.
function! scala#close()
  let g:scalaVimuxWindowOpen=g:scalaVimuxWindowOpen-1
  if (g:scalaVimuxWindowOpen == 0)
    call VimuxCloseRunner()
  endif
endfunction

"" Execute any tests associated with the current buffer.
function! scala#test()
  if (g:scalaVimuxWindowOpen > 0)
    let testRoot=substitute(bufname("%"), "main", "test", "")
    let testExists=filereadable(substitute(testRoot, "\\.scala", "Spec.scala", "")) || filereadable(substitute(testRoot, "\\.scala", "Test.scala", ""))
    if testExists
      call VimuxRunCommand('test')
    endif
  endif
endfunction

"" Ensure creating new Scala buffers, or opening existing files, opens an sbt
"" session, and that closing them closes that session.  If the buffer is saved
"" try to execute the tests that are associated with it.
autocmd BufRead,BufNewFile *.scala call scala#open()
autocmd BufDelete          *.scala call scala#close()
autocmd BufWritePost       *.scala call scala#test()

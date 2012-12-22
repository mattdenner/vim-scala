if exists('g:loaded_scala_md') || &cp
  finish
endif
let g:loaded_scala_md=1

"" Number of vimux windows open
let g:scalaVimuxWindowOpen=0
let g:scalaVimuxOpening=0

"" Identifies the companion file that should be opened alongside the current
"" buffer.  It says what action should be taken ('split' or 'new'), the
"" direction in which to do this ('botleft' or 'botright'), the filename.
function! scala#identifyCompanionFile()
  let scala#companionMapping={
    \ 'main': {'substitute': 'test', 'direction': 'botright', 'replacements': [''],                    'extensions': ['Test', 'Spec', 'Suite'] },
    \ 'test': {'substitute': 'main', 'direction': 'topleft',  'replacements': ['Test','Spec','Suite'], 'extensions': [''] }
    \ }

  for [key, mapping] in items(scala#companionMapping)
    let scalaRoot=substitute(bufname('%'), key, mapping['substitute'], '')
    if (scalaRoot != bufname('%'))
      for extension in mapping['extensions']
        for replacement in mapping['replacements']
          let filename=substitute(scalaRoot, replacement.'\.scala', extension.'.scala', '')
          if (filereadable(filename))
            return ['split', mapping['direction'], filename]
          endif
        endfor
      endfor

      return ['new', mapping['direction'], substitute(scalaRoot, '\.scala', 'Test.scala', '')]
    endif
  endfor

  return ['new', 'botright', 'foo']
endfunction

"" Opens the companion file in an appropriate split.
function! scala#openCompanionFile()
  if (g:scalaVimuxOpening == 0)
    let g:scalaVimuxOpening=1
    let testFileDetails=scala#identifyCompanionFile()
    exec testFileDetails[1] ' v' . testFileDetails[0] testFileDetails[2]
    let g:scalaVimuxOpening=0
  endif
endfunction

"" Opens a Vimux window with the sbt session started
function! scala#openSbt()
  if (g:scalaVimuxWindowOpen == 0)
    call VimuxRunCommand('sbt')
  endif
  let g:scalaVimuxWindowOpen=g:scalaVimuxWindowOpen+1
endfunction

"" Opens a vimux terminal with 'sbt' running in it and ensures that there is a 
"" test file, either creating a new one or opening the existing one in a
"" separate pane.
function! scala#open()
  call scala#openSbt()
""  call scala#openCompanionFile()
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
    let testFileDetails=scala#identifyCompanionFile()
    if (testFileDetails[0] == 'split')
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

autocmd BufNewFile,BufRead *.scala set filetype=scala
autocmd BufNewFile,BufRead *.sbt   set filetype=scala

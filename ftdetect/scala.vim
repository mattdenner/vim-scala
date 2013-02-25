"" Ensure that the filetype is correctly identified (duplicated in plugin/scala.vim)
autocmd BufNewFile,BufRead *.scala                 set filetype=scala
autocmd BufNewFile,BufRead *Spec.scala,*Test.scala set filetype=scalatest
autocmd BufNewFile,BufRead *.sbt                   set filetype=scala
autocmd FileType           scalatest               set syntax=scala

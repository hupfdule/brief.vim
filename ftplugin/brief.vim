" Vim filetype plugin for brief files (http://github.com/hupfdule/brief)
" Language:     Brief
" Maintainer:   Marco Herrn <marco@mherrn.de>
" Last Changed: 29. October 2019
" URL:          http://github.com/hupfdule/brief.vim
" License:      MIT?

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo&vim

" Folding ================================================================ {{{

  " Fixme: These are default folding settings. They should be refined
  " with settings.
  " TODO: Allow to specify sections that are folded by default
  setlocal foldexpr=brief#folding#foldexpr(v:lnum)
  setlocal foldmethod=expr
  setlocal foldlevel=1

" END Folding ============================================================ }}}


let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set fdm=marker :

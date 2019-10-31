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

" Completion ============================================================= {{{

  setlocal omnifunc=brief#completion#omnicomplete

" END Completion ========================================================= }}}

" Motions ================================================================ {{{

  nnoremap <buffer> ]] :call brief#motions#jump_to_section(1, 0)<cr>
  nnoremap <buffer> ][ :call brief#motions#jump_to_section(1, 1)<cr>
  nnoremap <buffer> [[ :call brief#motions#jump_to_section(0, 0)<cr>
  nnoremap <buffer> [] :call brief#motions#jump_to_section(0, 1)<cr>

" END Motions ============================================================ }}}

" Text objects =========================================================== {{{

  " inside section (starting with dot)
  xnoremap <buffer>  i. :call brief#textobjects#section(0)<cr>
  omap <buffer>  i. :normal Vi.<CR>
  " a section (starting with dot)
  xnoremap <buffer>  a. :call brief#textobjects#section(1)<cr>
  omap <buffer>  a. :normal Va.<CR>
  " inside markup section
  xnoremap <buffer>  im :call brief#textobjects#markup_section(0)<cr>
  omap <buffer>  im :normal Vim<CR>
  " a markup section
  xnoremap <buffer>  am :call brief#textobjects#markup_section(1)<cr>
  omap <buffer>  am :normal Vam<CR>

" END Text objects ======================================================= }}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set fdm=marker :

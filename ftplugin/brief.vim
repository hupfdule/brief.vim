" Vim filetype plugin for brief files (http://github.com/hupfdule/brief)
" Language:     Brief
" Maintainer:   Marco Herrn <marco@mherrn.de>
" Last Changed: 29. October 2019
" URL:          http://github.com/hupfdule/brief.vim
" License:      MIT

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

  " Section movement
  " TODO: xmap and omap
  nnoremap <buffer> ]] :call brief#motions#jump_to_section(1, 0)<cr>
  nnoremap <buffer> ][ :call brief#motions#jump_to_section(1, 1)<cr>
  nnoremap <buffer> [[ :call brief#motions#jump_to_section(0, 0)<cr>
  nnoremap <buffer> [] :call brief#motions#jump_to_section(0, 1)<cr>

  " Markup block movement
  nnoremap <buffer> ]} :call brief#motions#jump_to_markup_block(1, 0)<cr>
  nnoremap <buffer> ]{ :call brief#motions#jump_to_markup_block(1, 1)<cr>
  nnoremap <buffer> [{ :call brief#motions#jump_to_markup_block(0, 0)<cr>
  nnoremap <buffer> [} :call brief#motions#jump_to_markup_block(0, 1)<cr>

" END Motions ============================================================ }}}

" Text objects =========================================================== {{{

  " inside section (starting with dot)
  xnoremap <buffer>  i. :<c-u>call brief#textobjects#section(0)<cr>
  omap     <buffer>  i. :normal Vi.<CR>
  " a section (starting with dot)
  xnoremap <buffer>  a. :<c-u>call brief#textobjects#section(1)<cr>
  omap     <buffer>  a. :normal Va.<CR>
  " inside markup section
  xnoremap <buffer>  im :<c-u>call brief#textobjects#markup_section(0)<cr>
  omap     <buffer>  im :normal Vim<CR>
  " a markup section
  xnoremap <buffer>  am :<c-u>call brief#textobjects#markup_section(1)<cr>
  omap     <buffer>  am :normal Vam<CR>

" END Text objects ======================================================= }}}

" Commands =============================================================== {{{

  command! -buffer -nargs=? BriefToday           :call brief#helpers#set_today(<f-args>)
  " TODO: Provide default mapping? (nmap, imap)

  " TODO: Differentiate:
  "       - new empty
  "       - new, using current file as template
  "       - new, using specified file as template
  "       - new, prefill tex-template
  "       Possible workflow:
  "         - Open vim (empty)
  "         - get list of existing .brf files                 :call brief#external#list_brf_documents()
  "         - filter that list (FZF, clap, builtin)           :fzf funct, completeopt
  "         - selectign 1 file to use as template
  "         - automatically fill the buffer with that content :call brief#external#create_from_template(brf_template)
  "         Questions:
  "           - Can I use FZF for completing command arguments?
  "             I expect that I then need to define a cmap to call FZF
  command! -buffer -nargs=? BriefNew             :call brief#helpers#create_new(<f-args>)

  " TODO: Differentate:
  "       - no arg: Provide selectoin menu
  "       - with arg: set the specified one
  "       NO! Better use omnicompletion:
  "         - Jump to section .TEMPLATE
  "         - Jump to existing entry or start of next line
  "         - Open omnicompletion-menu
  "         - Jump back? May not be possible when omnicompletion still has
  "           to be processed.
  command! -buffer          BriefSwitchTemplate  :call brief#helpers#switch_template(<f-args>)<cr>

  " TODO: See above
  command! -buffer          BriefSwitchFrom      :call brief#helpers#switch_from(<f-args>)<cr>

  " TODO: Provide selection menu for opening existing .brf file
  "       - via FZF / vim-clap would be nice
  "       - but should also work without them
  "       Provide selection menu for selecting template .brf file for new .brf

  " TODO: What arguments will those commands get?
  command! -buffer          BriefTex             :call brief#external#tex(<f-args>)<cr>
  command! -buffer          BriefPdf             :call brief#external#pdf(<f-args>)<cr>
  command! -buffer          BriefPreview         :call brief#external#preview(<f-args>)<cr>

" END Commands =========================================================== }}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set fdm=marker :

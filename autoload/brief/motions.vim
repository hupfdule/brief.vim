let s:section_header_pattern       = '\v\C^\.[A-Z]+\s*$'
let s:markup_section_start_pattern = '\v\C^\.[a-z]+\-+\s*$'
let s:markup_section_end_pattern   = '\v\C^\-{2,}\s*$'

"" Jump to beginning or end of current/next or previous section
"
" @param {next} whether to jump to jump to the next or previous section
"               0 == jump to previous section
"               1 == jump to next section
" @param {to_end} whether to jump to the beginning or end of the section
"               0 == jump to the beginning of the section
"               1 == jump to the end of the section
function! brief#motions#jump_to_section(next, to_end) abort
  if (a:next)
    let l:target_section_header = search(s:section_header_pattern, 'Wn')
  else
    let l:target_section_header = search(s:section_header_pattern, 'Wbn')
  endif

  if a:to_end
    let l:last_non_blank_line = prevnonblank(l:target_section_header - 1)
    echo l:last_non_blank_line . " " . line('.')
    if l:last_non_blank_line ==# line('.')
      " if we already are at the end of the current section, jump to the
      " end of the next section
      " FIXME: This doesn't work in empty sections, like:
      "     .NUDEL
      "     .BAUER
      "     some bauer content
      call cursor(l:target_section_header, 0)
      call brief#motions#jump_to_section(a:next, a:to_end)
      return
    else
      " FIXME: This doesn't work in empty sections, like:
      "     .NUDEL
      "     .BAUER
      "     some bauer content
      let l:target_line = l:last_non_blank_line
    endif
  else
    let l:target_line = l:target_section_header
  endif

  call cursor(l:target_line, 0)
endfunction

"" Jump to beginning or end of current/next or previous markup block
"
" @param {next} whether to jump to jump to the next or previous markup block
"               0 == jump to previous markup block
"               1 == jump to next markup block
" @param {to_end} whether to jump to the beginning or end of the markup block
"               0 == jump to the beginning of the markup block
"               1 == jump to the end of the markup block
function! brief#motions#jump_to_markup_block(next, to_end) abort

endfunction

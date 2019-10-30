"" {{{2
" Omnifunc for finding possible template names or sender ids.
"
" See ':h complete-functions'
function! brief#completion#omnicomplete(findstart, base) abort "{{{1
  if a:findstart
    " Find start of completion item
    " This checks whether the current line is the content line of either
    " .TEMPLATE or .FROM and returns the position of the first character on
    " the line
    let l:prev_line = trim(s:get_prev_line(line('.')))
    if l:prev_line ==# '.TEMPLATE' || l:prev_line ==# '.FROM'
      let b:completion_type = l:prev_line
      let l:cur_pos = getpos('.')
      execute 'normal! ^'
      let l:start = col('.')
      call setpos('.', l:cur_pos)
      return l:start - 1
    else
      return -3
    endif

  else
    " Find possible completion entries
    if b:completion_type ==# '.TEMPLATE'
      return brief#external#list_tex_templates()
    elseif b:completion_type ==# '.FROM'
      return brief#external#list_senders()
    else
      echohl ErrorMsg | echo 'Invalid completion type: ' . b:completion_type | echohl None
    endif
  endif
endfunction "}}}1

"" {{{2
" Change the content of the given section.
"
" This removes any existing content or insert a new line below the section
" header and call the omni-completion menu.
" Be awar that this only works for one-line contents and is only supported
" for the .TEMPLATE and .FROM sections.
"
" @param {section} the section to change. Must include the full section
" header (including the leading dot).
function! brief#completion#change_section(section) abort "{{{1
  let l:cur_pos = getpos('.')
  call cursor(1, 1)
  if a:section ==# '.TEMPLATE' || a:section ==# '.FROM'
    let l:section_header = search('\v\C^\s*\' . a:section . '\s*$', 'wc')
    if l:section_header ==# 0
      echohl ErrorMsg | echo 'Section ' . section . ' not found!' | echohl None
      return
    endif

    call cursor(l:section_header + 1, 0)

    let l:next_section_header = search('\v\C^\.[A-Z]+\s*$', 'Wn')
    " Jump to the content line, delete it and start omni-completion
    " or create a new line and start omni-completion
    let l:content_line = search('\v\C\w+', '', l:next_section_header - 1)
    echom l:section_header
    echom l:next_section_header
    echom l:content_line
    if l:content_line !=# 0
      execute 'normal! ^C'
    else
      execute 'normal! o'
    endif
    startinsert
    call feedkeys("\<c-x>\<c-o>")
  else
    echohl ErrorMsg | echo "Invalid section for completion: " . a:section | echohl None
  endif
endfunction "}}}1

"" {{{2
" Return the previous line that is not empty and not a comment.
"
" @param  {cur_line} the line number of the line from which to search the previous line
" @return the content of the found previous line or an empty string if no
"         such line could be found
function! s:get_prev_line(cur_line) abort "{{{1
  let l:line = a:cur_line
  while l:line > 0
    let l:line -= 1
    if l:line !~# '^\s*$' && l:line !~# '^\s*#'
      return getline(l:line)
    endif
  endwhile

  return ""
endfunction "}}}1

" vim: set foldmethod=marker :

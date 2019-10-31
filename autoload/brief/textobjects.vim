let s:section_header_pattern       = '\v\C^\.[A-Z]+\s*$'
let s:markup_section_start_pattern = '\v\C^\.[a-z]+\-+\s*$'
let s:markup_section_end_pattern   = '\v\C^\-{2,}\s*$'

"" {{{2
" Textobject for a brief section.
"
" Depending of parameter {around} it may select only the content of the
" current section or the whole section with section header and trailing
" empty lines.
"
" @param {around} whether to select "a" section or "inside" a section
"        0: inside section
"        1: a section
function! brief#textobjects#section(around) abort "{{{1
  let l:prev_section_header = search(s:section_header_pattern, 'Wbcn')
  let l:next_section_header = search(s:section_header_pattern, 'Wn')

  " if no previous header exists, this is not a section
  if l:prev_section_header ==# 0
    " FIXME: Why did the cursor move to the start of the line?
    echohl ErrorMsg | echo "Not inside a section" | echohl None
    return
  endif

  " if there is no next section header, this section ends at the end of file
  if l:next_section_header ==# 0
    let l:next_section_header = line('$') + 1
  endif

  if a:around
    let l:start = l:prev_section_header
    let l:end = l:next_section_header - 1
  else
    let l:start = l:prev_section_header + 1
    let l:end = prevnonblank(l:next_section_header - 1)
    if l:end < l:start
      echohl ErrorMsg | echo "No content in section " . getline(l:prev_section_header) | echohl None
      return
    endif
  endif

  " if there is no next section, select to the end of the file
  if l:end <= 0
    let l:end = line('$')
  endif

  call cursor(l:start, 0)
  normal! V
  call cursor(l:end, 0)
  normal! $
endfunction "}}}1

"" {{{2
" Textobject for a markup section.
"
" Depending of parameter {around} it may select only the content of the
" current markup section or the whole markup section with surrounding
" delimiters.
"
" @param {around} whether to select "a" markup section or "inside" a markup section
"        0: inside markup section
"        1: a markup section
function! brief#textobjects#markup_section(around) abort "{{{1
  let l:opening_delimiter = search(s:markup_section_start_pattern, 'Wbcn')
  let l:closing_delimiter = search(s:markup_section_end_pattern, 'Wcn')
  " Search also for the previous end delimiter to check whether we are
  " really _inside_ a markup sectin
  let l:prev_closing_delimiter = search(s:markup_section_end_pattern, 'Wbcn')

  " Stop if we are not inside a markup section
  if l:opening_delimiter ==# 0 || l:closing_delimiter ==# 0 || l:opening_delimiter < l:prev_closing_delimiter
    " FIXME: Why did the cursor move to the start of the line?
    echohl ErrorMsg | echo "Not inside a markup section" | echohl None
    return
  endif

  if a:around
    let l:start = l:opening_delimiter
    let l:end = l:closing_delimiter
  else
    let l:start = l:opening_delimiter + 1
    let l:end = l:closing_delimiter - 1
    if l:end <= l:start
      echohl ErrorMsg | echo "No content in markup section " . getline(l:opening_delimiter) | echohl None
      return
    endif
  endif

  call cursor(l:start, 0)
  normal! V
  call cursor(l:end, 0)
  normal! $
endfunction "}}}1

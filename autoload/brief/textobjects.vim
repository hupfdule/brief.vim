let s:section_header_pattern       = '\v\C^\.[A-Z]+\s*$'
let s:markup_section_start_pattern = 'v\C^\.[a-z]+\-+\s*$'
let s:markup_section_end_pattern   = '\v\C\-{2,}\s*$'

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
  let s:prev_section_header = search(s:section_header_pattern, 'Wbcn')
  let s:next_section_header = search(s:section_header_pattern, 'Wn')
  " FIXME: What to do if either prev or next cannot be found?

  if a:around
    let l:start = s:prev_section_header
    let l:end = s:next_section_header - 1
  else
    let l:start = s:prev_section_header + 1
    let l:end = prevnonblank(s:next_section_header - 1)
    if l:end < l:start
      echohl ErrorMsg | echo "No content in section " . getline(s:prev_section_header) | echohl None
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
endfunction "}}}1

""
"
"
function! brief#helpers#set_today() abort
  " TODO:
  "      Find .DATE
  "      Append current date to that line (or replace existing)
  " FIXME: Use a helper function for replaceOrAppend?
  " FIXME: Add .DATE if missing? This rises the question: Where to place
  "        it?
  " FIXME: Allow specifying the date format?
  let l:old_pos = getpos('.')

  call cursor(1, 1)
  let l:date_header_lnum = search('^\.DATE\s*', 'cnW')

  " Do nothing if there is no .DATE header
  " FIXME: Create it instead?
  if (l:date_header_lnum !=# 0)
    let l:today = strftime('%Y-%m-%d', localtime())

    call cursor(l:date_header_lnum, 0)
    let l:next_header_lnum = search('^\.\S\+\s*', 'nW')
    let l:existing_content_lnum = nextnonblank(l:date_header_lnum + 1)

    if (l:next_header_lnum !=# 0 && l:existing_content_lnum <# l:next_header_lnum)
      " Replace existing content …
      call setline(l:existing_content_lnum, l:today)
    else
      " … or append new if there is no existing content
      call append(l:date_header_lnum, l:today)
    endif
  endif

  call setpos('.', l:old_pos)
endfunction


""
" Replaces the whole content of a section with the given new content.
"
" Empty leading and trailing lines will be left intact.
"
" @parameter {section_name}
" @parameter {new_content}
function! s:appendOrReplace(section_name, new_content) abort

endfunction


""
" Fill the buffer with the content for a new .brf file.
"
" @parameter {brf_template} The .brf file to use as template.
"                           If this is an empty string, no template will be
"                           used. Otherwise it must the path to the file.
function! brief#helpers#create_new(brf_template) abort
  " TODO: Check for validity of 'brf_template'
  " TODO: Empty current file? Or create a new buffer?
  " TODO: Prefill some fields
  " TODO: Place cursor on sane position
  let l:brief_args = ''
  if a:brf_template !=# v:null && a:brf_template !=# ''
    let l:brief_args .= '--tex-template ' . a:brf_template
  endif
  let l:new_content = systemlist(brief#external#get_executable() . ' create ' . l:brief_args)
  call append(0, l:new_content)

  call brief#helpers#set_today()

  call cursor(1, 1)
  call search('^\.SUBJECT', 'cW')
endfunction

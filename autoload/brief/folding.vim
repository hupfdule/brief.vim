""
" Return the fold level of the given line.
function! brief#folding#foldexpr(lnum)
    let l0 = getline(a:lnum)
    if l0 =~# '\v\C^\.[A-Z]+\s*$'
      " Section start
      return '>1'
    elseif l0 =~# '\v\C^\.[a-z]+\-+\s*$'
      " markup section start
      return 'a1'
    elseif l0 =~# '\v\C^\-{2,}\s*$'
      " markup section end
      return 's1'
    else
      return '='
    endif
endfunction

""
" Prints the fold levels for all lines in the current file.
" Also displays any errors on folding.
" Taken from https://vi.stackexchange.com/a/19916/21417
function! brief#folding#debug() abort
  let fold_levels = map(range(1, line('$')), 'v:val . "\t" . brief#folding#foldexpr(v:val) . "\t" . getline(v:val)')
  for fl in fold_levels
    echo fl
  endfor
endfunction

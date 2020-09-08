" Vim syntax file
" Language:    Brief
" Maintainer:  Marco Herrn <marco@mherrn.de>
" Last Change: 2019-10-17
" Remark:      Syntax file for the brief application (https://github.com/hupfdule/brief)

if exists("b:current_syntax")
  finish
endif

" Load the tex syntax file to have proper syntax highlighting for TeX.
" The remaining content here is our brief specific syntax elements and some
" special chars that we handle differently than pure LaTeX.
runtime syntax/tex.vim

syntax keyword briefSectionName TEMPLATE FROM TO POSTAL DATE SUBJECT OPENING CONTENT CLOSING ENCLOSURES
" FIXME: This should only highlight correct sectionKeywords
syntax match   briefSection /\v\C^\.[A-Z]+\s*$/
syntax match   briefSectionMarkup /\v\C^\.[a-z]+\s*$/
" TODO: Set default highlight for blocks to latex?
syntax region  briefMarkupBlock start=/\v\C^\.[a-z]+\-+\s*$/ end=/\v\C^\-{2,}\s*$/
syntax match   briefComment /\v\C^#.*/


" Include highlighting of markup sections
" see :h sh-awk
if !exists('g:brief_fenced_languages')
  let g:brief_fenced_languages = ['markdown', 'asciidoc', 'java']
endif
for s:type in g:brief_fenced_languages
  exe 'syn include @' . s:type . 'Markup syntax/' . s:type . '.vim'
  " section markup
  " .MY_SECTION
  " .md
  " …
  " .NEXT_SECTION
  " FIXME: This doesn't work
  exe 'syn region ' . s:type . 'Region matchgroup=briefMarkupFence start=/\v\C^\.[A-Z]+\s*\n\zs\.' . s:type . '\s*$/ keepend end=/\v\C^\ze\.[A-Z]*\s*$/ contains=@' . s:type . 'Markup'

  " block markup
  " .md-
  " …
  " ----
  exe 'syn region ' . s:type . 'Region matchgroup=briefMarkupFence start=/\v\C^\.' . s:type . '\-+\s*$/ keepend end=/\v\C^-{2,}\s*$/ contains=@' . s:type . 'Markup'

  unlet! b:current_syntax
endfor


" Now specify the actual highlighting
hi def link briefComment        Comment
hi def link briefSection        Title
hi def link briefSectionMarkup  Identifier
hi def link briefMarkupBlock    Identifier
hi def link briefMarkupFence    Comment

" TODO: Here we can redefine some syntax elements that would be illegal in
" Tex, but are allowed in brief (like underscores, carets, etc.)
hi link texOnlyMath         Identifier

let b:current_syntax = "brief"
""if main_syntax ==# 'brief'
""	unlet main_syntax
""endif

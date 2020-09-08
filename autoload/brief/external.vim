" TODO: Let the location of the brief command being specified by a
" setting? Then it doesn't need to be in the PATH
" TODO: Use job_start (vim) / jobstart (neovim) for calling external
" commands. That allows better separation of stdout/stderr.

let s:default_brief_executable = '/home/mherrn/projekte/brief3/brief'


""
" Installs the brief executable.
"
" This download the last released binary from the github repository.
function! brief#external#install_brief_executable() abort
endfunction

""
" Returns the names of the available tex templates.
"
" This calls the command 'brief list-tex-templates'. Make sure that the 'brief'
" command is in your path before calling this function.
function! brief#external#list_tex_templates() abort
  let tex_templates = systemlist(brief#external#get_executable() . ' list-tex-templates')
  return tex_templates
endfunction

""
" Returns the available sender-ids.
"
" This calls the command 'brief list-senders'. Make sure that the 'brief'
" command is in your path before calling this function.
function! brief#external#list_senders() abort
  " TODO: To be usable for omni-completion this should also return some
  "       context like:
  "       - the actual fields for this address for the preview window
  "       BUT: How to display that in a balloon? It doesn't make much sense
  "       to use the preview here, because that would remain on screen
  "       after completion. We only need this info while selecting in the
  "       omni-complete menu.
  let senders = systemlist(brief#external#get_executable() . ' list-senders')
  return senders
endfunction

""
" Returns the .brf file in the configured document roots.
" FIXME: Also support to give the search directories via function
" arguments?
"
" This calls the command 'brief list'. Make sure that the 'brief'
" command is in your path before calling this function.
function! brief#external#list_brf_documents() abort
  let brf_files = systemlist(brief#external#get_executable() . ' list')
  return brf_files
endfunction

function! brief#external#get_executable() abort
  return get(g:, 'brief_executable', s:default_brief_executable)
endfunction




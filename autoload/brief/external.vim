""
" Installs the brief executable.
"
" This download the last released binary from the github repository.
function brief#external#install_brief_executable() abort
endfunction

""
"
function brief#external#list_tex_templates() abort
  let tex_templates = systemlist('brief list-tex-templates')
  return tex_templates
endfunction

""
" Returns the available sender-ids.
"
" This calls the command 'brief list-senders'. Make sure that the 'brief'
" command is in your path before calling this function.
function brief#external#list_senders() abort
  " TODO: To be usable for omni-completion this should also return some
  "       context like:
  "       - the actual fields for this address for the preview window
  let senders = systemlist('brief list-senders')
  return senders
endfunction

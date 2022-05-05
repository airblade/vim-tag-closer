if exists('g:loaded_tag_closer') || &cp || v:version < 700
  finish
endif
let g:loaded_tag_closer = 1


let s:void_elements = ['area', 'area', 'base', 'br', 'col', 'embed',
      \ 'hr', 'img', 'input', 'link', 'meta', 'source', 'track', 'wbr']

function! s:tag_name(tag)
  return matchstr(a:tag, '\v^\</?\zs\a\w+(\-\a\w+)?')
endfunction

function! s:is_void_element(tag)
  return index(s:void_elements, s:tag_name(a:tag)) >= 0
endfunction

function! s:is_closing(tag)
  return a:tag[1] == '/'
endfunction

function! s:closing_tag(opening_tag)
  return '</'.s:tag_name(a:opening_tag).'>'
endfunction

function! s:opening_tag(closing_tag)
  return '<'.s:tag_name(a:closing_tag).'[^>]*>'
endfunction

" Moves to previous occurrence of pattern and returns the matching string.
function! s:find_previous(pattern)
  let [lnum, col] = searchpos(a:pattern, 'bW')
  return matchstr(getline(lnum), a:pattern, col-1)
endfunction

function! s:previous_unclosed_tag()
  let tag = s:find_previous('<[^>]\+>')

  if empty(tag)
    return ''
  elseif s:is_void_element(tag)
    call s:find_previous(tag)
    return s:previous_unclosed_tag()
  elseif s:is_closing(tag)
    call searchpair(s:opening_tag(tag), '', tag.'\zs', 'bW')
    return s:previous_unclosed_tag()
  else
    return tag
  endif
endfunction

function! s:append_closing_tag(opening_tag)
  execute "normal! a".s:closing_tag(a:opening_tag)
endfunction


function! CloseTag()
  let [lnum, col] = getcurpos()[1:2]
  let tag = s:previous_unclosed_tag()
  call cursor(lnum, col)
  if len(tag)
    call s:append_closing_tag(tag)
  endif
endfunction


noremap <Plug>(CloseTag) :call CloseTag()<CR>

nmap g/ <Plug>(CloseTag)
imap <C-G>/ <C-O><Plug>(CloseTag)

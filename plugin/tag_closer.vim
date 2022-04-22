if exists('g:loaded_tag_closer') || &cp || v:version < 700
  finish
endif
let g:loaded_tag_closer = 1


let s:void_elements = ['area', 'area', 'base', 'br', 'col', 'embed',
      \ 'hr', 'img', 'input', 'link', 'meta', 'source', 'track', 'wbr']

function! s:tag_name(tag)
  return matchstr(a:tag, '\v^\</?\zs\a+(\-\a+)?')
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

function! s:search_back_for(re)
  let [lnum, col] = searchpos(a:re, 'bW')
  return matchstr(getline(lnum), a:re, col-1)
endfunction

" Returns the first unclosed tag, searching backwards.
" If no unclosed tag is found, returns an empty string.
"
" a:1 - a previous opening tag from which to begin the search.
function! s:previous_unclosed_tag(...)
  if a:0
    call s:search_back_for(a:1)
    return s:previous_unclosed_tag()
  endif

  let tag = s:search_back_for('<[^>]\+>')

  if empty(tag)
    return ''
  elseif s:is_void_element(tag)
    return s:previous_unclosed_tag(tag)
  elseif s:is_closing(tag)
    return s:previous_unclosed_tag(s:opening_tag(tag))
  else
    return tag
  endif
endfunction

function! s:insert_closing_tag(opening_tag)
  execute "normal! a".s:closing_tag(a:opening_tag)
endfunction


function! CloseTag()
  let [lnum, col] = getcurpos()[1:2]
  let tag = s:previous_unclosed_tag()
  call cursor(lnum, col)
  if len(tag)
    call s:insert_closing_tag(tag)
  endif
endfunction


nnoremap <Plug>(CloseTag) :call CloseTag()<CR>

nmap g/ <Plug>(CloseTag)
imap <C-G>/ <C-O><Plug>(CloseTag)

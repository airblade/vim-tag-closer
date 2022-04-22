function SetUp()
  enew
  call setline(1, ['<html lang="en">', '<body>', '<foo-bar>', '<area>', '<ul class="foo">', '<li>one</li>', '<li>two'])
  normal! G$
endfunction

function TearDown()
  bdelete!
endfunction


function! Test_tag_name()
  let sid = matchstr(execute('filter plugin/tag_closer.vim scriptnames'), '\d\+')
  let TagName = function("<SNR>".sid."_tag_name")

  call assert_equal('foo', call(TagName, ['<foo>']))
  call assert_equal('foo', call(TagName, ['<foo id="bar">']))
  call assert_equal('foo', call(TagName, ['</foo>']))
  call assert_equal('foo', call(TagName, ['<foo />']))

  call assert_equal('foo-bar', call(TagName, ['<foo-bar>']))
  call assert_equal('foo-bar', call(TagName, ['<foo-bar id="bar">']))
  call assert_equal('foo-bar', call(TagName, ['</foo-bar>']))
  call assert_equal('foo-bar', call(TagName, ['<foo-bar />']))
endfunction


function! Test_normal_mode()
  call CloseTag()
  call assert_equal('<li>two</li>', getline('$'))

  call CloseTag()
  call assert_equal('<li>two</li></ul>', getline('$'))

  call CloseTag()
  call assert_equal('<li>two</li></ul></foo-bar>', getline('$'))

  call CloseTag()
  call assert_equal('<li>two</li></ul></foo-bar></body>', getline('$'))

  call CloseTag()
  call assert_equal('<li>two</li></ul></foo-bar></body></html>', getline('$'))

  call CloseTag()
  call assert_equal('<li>two</li></ul></foo-bar></body></html>', getline('$'))
endfunction


function! Test_normal_mode_map()
  normal g/
  call assert_equal('<li>two</li>', getline('$'))
endfunction


function! Test_insert_mode()
  execute "normal a\<C-G>/"
  call assert_equal('<li>two</li>', getline('$'))
endfunction

function SetUp()
  enew
endfunction

function TearDown()
  bdelete!
endfunction


function! Test_tag_name()
  call setline(1, ['<html lang="en">', '<body>', '<foo-bar>', '<area>', '<ul class="foo">', '<li>one</li>', '<li>two'])
  normal! G$

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


function! Test_close_tag()
  call setline(1, ['<html lang="en">', '<body>', '<foo-bar>', '<area>', '<ul class="foo">', '<li>one</li>', '<li>two'])
  normal! G$

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
  call setline(1, ['<html lang="en">', '<body>', '<foo-bar>', '<area>', '<ul class="foo">', '<li>one</li>', '<li>two'])
  normal! G$

  normal g/
  call assert_equal('<li>two</li>', getline('$'))
endfunction


function! Test_insert_mode()
  call setline(1, ['<html lang="en">', '<body>', '<foo-bar>', '<area>', '<ul class="foo">', '<li>one</li>', '<li>two'])
  normal! G$

  execute "normal a\<C-G>/"
  call assert_equal('<li>two</li>', getline('$'))
endfunction


function! Test_intermediate_closed_tags_with_same_name()
  call setline(1, ['<html>', '<body>', '<div>', '<div>', '</div>', '<p>Text</p>'])
  normal! G$

  normal g/
  call assert_equal('<p>Text</p></div>', getline('$'))

  normal g/
  call assert_equal('<p>Text</p></div></body>', getline('$'))
endfunction

# vim-tag-closer

A Vim plugin which closes HTML tags on demand.

There are quite a few tag-closing plugins already but they all close tags eagerly, i.e. they generate the closing tag at the same time as the opening tag.  I prefer to put in the closing tags when I get to where they should go.

Having said that, I don't want to actually type out each closing tag.  The computer can do that for me.

Ignores [void elements](https://html.spec.whatwg.org/multipage/syntax.html#void-elements).


### Installation

Install like every other Vim plugin :)


### Usage

Append the appropriate closing tag at the cursor with:

- Insert-mode: <kbd>\<C-G>/</kbd>
- Normal-mode: <kbd>g/</kbd>


### Intellectual property

Copyright 2022 Andrew Stewart.  Released under the MIT licence.

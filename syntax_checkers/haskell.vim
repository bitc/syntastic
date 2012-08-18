"============================================================================
"File:        haskell.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Anthony Carapetis <anthony.carapetis at gmail dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================
if exists("loaded_haskell_syntax_checker")
    finish
endif
let loaded_haskell_syntax_checker = 1

if !exists('g:syntastic_haskell_checker_prog')
  let g:syntastic_haskell_checker_prog = "ghc-mod"
endif

"bail if the user doesnt have an available tool installed
if !executable(split(g:syntastic_haskell_checker_prog)[0])
    finish
endif

if !exists('g:syntastic_haskell_checker_args')
    if g:syntastic_haskell_checker_prog == "ghc-mod"
        let g:syntastic_haskell_checker_args = '--hlintOpt="--language=XmlSyntax"'
    else
        let g:syntastic_haskell_checker_args = ''
    endif
endif

function! SyntaxCheckers_haskell_GetLocList()
    if g:syntastic_haskell_checker_prog == "ghc-mod"
        let ghcmod = 'ghc-mod ' . g:syntastic_haskell_checker_args
        let makeprg =
              \ "{ ".
              \ ghcmod . " check ". shellescape(expand('%')) . "; " .
              \ ghcmod . " lint " . shellescape(expand('%')) . ";" .
              \ " }"
    else
        let makeprg = g:syntastic_haskell_checker_prog . ' ' . g:syntastic_haskell_checker_args . ' ' . shellescape(expand('%'))
    endif

    let errorformat= '\%-Z\ %#,'.
                    \ '%W%f:%l:%c:\ Warning:\ %m,'.
                    \ '%E%f:%l:%c:\ %m,'.
                    \ '%E%>%f:%l:%c:,'.
                    \ '%+C\ \ %#%m,'.
                    \ '%W%>%f:%l:%c:,'.
                    \ '%+C\ \ %#%tarning:\ %m,'


    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

function! SyntaxCheckers_lhaskell_GetLocList()
    return SyntaxCheckers_haskell_GetLocList()
endfunction

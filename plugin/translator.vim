if exists('translator_loaded')
    finish
endif
let translator_loaded = 1

let g:translator_enabled = 1

let g:translate_from = 'en'
let g:translate_to = 'zh'

let s:language = ['zh', 'ja', 'ko', 'en', 'de']

function! s:translator_swap()
    let tmp = g:translate_from
    let g:translate_from = g:translate_to
    let g:translate_to = tmp
endfunction

function! s:translate_from(...)
    if a:0
        let g:translate_from = a:1
    else
        echo g:translate_from
    endif
endfunction

function! s:translate_to(...)
    if a:0
        let g:translate_to = a:1
    else
        echo g:translate_to
    endif
endfunction

function! s:get_language(a, l, p)
    if len(a:a) == 0
        return s:language
    endif
    let rst = []
    for lan in s:language
        if match(lan, a:a) == 0
            call add(rst, lan)
        endif
    endfor
    return rst
endfunction

function! <sid>handle_translate_object()
    let q = getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]
    call _translator_translate(g:translate_from, g:translate_to, q)
endfunction

command! -nargs=1 Translate call _translator_translate(g:translate_from, g:translate_to, <args>)
command! -nargs=? -complete=customlist,<sid>get_language TranslateFrom call <sid>translate_from(<f-args>)
command! -nargs=? -complete=customlist,<sid>get_language TranslateTo call <sid>translate_to(<f-args>)
command! -nargs=0 TranslatorEnable let g:translator_enabled = 1
command! -nargs=0 TranslatorDisable let g:translator_enabled = 0
command! -nargs=0 TranslatorSwap call s:translator_swap()

vnoremap <silent> tr :<C-u>call <sid>handle_translate_object()<CR>

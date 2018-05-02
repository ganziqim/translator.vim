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
    let q = s:get_visual_selection()
    if q != ""
        call _translator_translate(g:translate_from, g:translate_to, q)
    else
        echo "No text is selected"
    endif
endfunction

function! s:get_visual_selection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ""
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]

    let newlines = []
    for line in lines
        let line = substitute(line, '^\s*', "", "")
        let line = substitute(line, '\s*$', "", "")
        if line != ""
            call add(newlines, line)
        endif
    endfor
    return join(newlines, "%0A")
endfunction

command! -nargs=1 Translate call _translator_translate(g:translate_from, g:translate_to, <args>)
command! -nargs=? -complete=customlist,<sid>get_language TranslateFrom call <sid>translate_from(<f-args>)
command! -nargs=? -complete=customlist,<sid>get_language TranslateTo call <sid>translate_to(<f-args>)
command! -nargs=0 TranslatorEnable let g:translator_enabled = 1
command! -nargs=0 TranslatorDisable let g:translator_enabled = 0
command! -nargs=0 TranslatorSwap call s:translator_swap()

vnoremap <silent> tr :<C-u>call <sid>handle_translate_object()<CR>

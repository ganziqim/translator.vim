if exists('translator_loaded')
    finish
endif
let translator_loaded = 1

let g:translator_enabled = 1

let g:translate_from = 'en'
let g:translate_to = 'zh'

command! -nargs=1 Translate call _translator_translate(g:translate_from, g:translate_to, <args>)
command! -nargs=0 TranslatorEnable let g:translator_enabled = 1
command! -nargs=0 TranslatorDisable let g:translator_enabled = 0

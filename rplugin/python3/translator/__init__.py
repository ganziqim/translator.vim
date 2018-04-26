import neovim
import requests


@neovim.plugin
class Translator(object):

    """The handler of translator.vim"""

    def __init__(self, nvim):
        self.nvim = nvim

    @neovim.function('_translator_translate')
    def get_translate(self, args):
        url = 'https://translate.google.cn/translate_a/single?client=gtx&\
sl={0}&tl={1}&hl=zh-CN&dt=t&dt=bd&ie=UTF-8&oe=UTF-8&dj=1&\
source=icon&q={2}'
        r = requests.get(url.format(args[0], args[1], args[2])).json()
        self.nvim.command('echo "{0}"'.format(r['sentences'][0]['trans']))

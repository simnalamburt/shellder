<img src="http://cdn.bulbagarden.net/upload/4/40/090Shellder.png"
  align=left width=175px height=175px>

shellder
========
> Things are beautiful if you love them. ― *[Jean Anouilh]*<br>
[![i-license]](/LICENSE)

<br>

![](http://i.imgur.com/xZJHgq8.png)

1. **Speed** ― Carefully optimized for slow environments like msys2
2. **No solarized** ― xterm256 colors are beautiful enough, inspired by [seoul256.vim]
3. **zsh** + **fish** support

Installation
--------
### fish
Use [chips]. Add to `~/.config/chips/plugin.yaml`:

```yaml
github:
- simnalamburt/shellder
```

Then run `chips`.

### zsh
Use [zplug]. Add below to your `.zshrc`:

```zsh
zplug 'simnalamburt/shellder', as:theme
```

## Fonts
You'll need a powerline patched font. If you don't have one, download one or
patch some fonts on you own.

- https://github.com/powerline/fonts
- https://github.com/ryanoasis/nerd-fonts

--------

[MIT License] © [simnalamburt] et [al]

[Jean Anouilh]:   https://en.wikipedia.org/wiki/Jean_Anouilh
[seoul256.vim]:   https://github.com/junegunn/seoul256.vim
[zplug]:          https://github.com/zplug/zplug
[chips]:          https://github.com/xtendo-org/chips
[MIT License]:    https://opensource.org/licenses/MIT
[simnalamburt]:   https://github.com/simnalamburt
[al]:             https://github.com/simnalamburt/shellder/graphs/contributors

[i-license]:      https://img.shields.io/badge/license-MIT-blue.svg

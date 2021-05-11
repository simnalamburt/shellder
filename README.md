**UNMAINTAINED**: I don't use MSYS2 anymore so I don't maintain this project
anymore. If you want to use shellder, consider the alternatives below:

1.  [powerlevel10k](https://github.com/romkatv/powerlevel10k)
    - Lowest latency. Utilizes async tasks and gitstatusd.
    - Only for ZSH
    - Not suits with MSYS2 or Cygwin since it's a big shell scripts. (But who uses MSYS2/Cygwin while we have WSL2?)
2.  [starship](https://starship.rs/)
    - Higher latency than powerlevel10k, but still it's faster than most shell themes.
    - Compatible with many shell environments (i.e. Powershell, bash, tcsh, fish, ...)
    - No slowdown in MSYS2 or Cygwin since it's a Rust binary not a shell script.

&nbsp;

--------

&nbsp;

<img align=left width=175px height=175px
src="https://raw.githubusercontent.com/simnalamburt/i/master/shellder/shellder.png">

shellder
========
1. **No solarized** ― xterm256 colors are beautiful enough
2. **zsh** + **fish** support
3. **Speed** ― Carefully optimized for slow environments like MSYS2

&nbsp;

![screenshot image of shellder](https://raw.githubusercontent.com/simnalamburt/i/master/shellder/screenshot.png)

Installation
--------
You can install shellder via various plugin managers.

### Zsh, [zinit]
```zsh
# ~/.zshrc
zinit light simnalamburt/shellder
```

### Fish, [chips]
```yaml
# ~/.config/chips/plugin.yaml
github:
- simnalamburt/shellder
```

### Fish, [oh-my-fish]
```yaml
# ~/.config/chips/plugin.yaml
github:
- simnalamburt/shellder
```

&nbsp;

Configuration
-------
You can turn off Fish-like path shrinking by adding the following to your `~/.zshrc`:

```zsh
# ~/.zshrc
export SHELLDER_KEEP_PATH=1
```

&nbsp;

## Fonts
You'll need a powerline patched font. If you don't have one, download one or
patch some fonts on you own.

- https://github.com/powerline/fonts
- https://github.com/ryanoasis/nerd-fonts

&nbsp;

--------
*shellder* is primarily distributed under the terms of both the [MIT license]
and the [Apache License (Version 2.0)]. See [COPYRIGHT] for details.

[zinit]: https://github.com/zdharma/zinit
[chips]: https://github.com/xtendo-org/chips
[oh-my-fish]: https://github.com/oh-my-fish/oh-my-fish
[MIT license]: LICENSE-MIT
[Apache License (Version 2.0)]: LICENSE-APACHE
[COPYRIGHT]: COPYRIGHT

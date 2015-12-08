## agnoster

A fish theme optimized for people who use:

* Solarized
* Git
* Mercurial (requires 'hg prompt')
* SVN
* Unicode-compatible fonts and terminals (I use iTerm2 + Menlo)

For Mac users, I highly recommend iTerm 2 + Solarized Dark

![agnoster theme](https://f.cloud.github.com/assets/1765209/255379/452c668e-8c0b-11e2-8a8e-d1d13e57d15f.png)


#### Characteristics

* If the previous command failed (✘)
* User @ Hostname (if user is not DEFAULT_USER, which can then be set in your profile)
* Git/HG/SVN status
* Branch () or detached head (➦)
* Current branch / SHA1 in detached head state
* Dirty working directory (±, color change)
* Working directory
* Elevated (root) privileges (⚡)
* Current virtualenv (Python)
You will probably want to disable the default virtualenv prompt. Add to your [`init.fish`](https://github.com/oh-my-fish/oh-my-fish#dotfiles):
`set --export VIRTUAL_ENV_DISABLE_PROMPT 1`
* Indicate vi mode


Ported from https://gist.github.com/agnoster/3712874.

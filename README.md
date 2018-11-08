# Aria's home folder configuration

Instructions on setting up a new workspace:

```sh
xcode-select --install
```

```sh
cd ~
git clone https://github.com/ariabuckles/home.git
cd home
make workspace
```

Or, to run installation without the homebrew setup included in workspace:

```
cd ~
git clone https://github.com/ariabuckles/home.git
cd home
make install
```

Note that these will prompt for my passwords to decrypt .secrets.env,
but the rest should be pretty generic. Disclaimer: I don't offer much
support for this repo; it's just for me.

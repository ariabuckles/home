"Enable nvim-colorizer.lua: https://github.com/norcalli/nvim-colorizer.lua
if has("nvim") && exists('g:loaded_colorizer') && &termguicolors
  lua require'colorizer'.setup()
endif

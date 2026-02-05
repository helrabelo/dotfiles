-- Add your custom plugins here
-- Every spec file under the "plugins" folder will be loaded automatically by lazy.nvim
--
-- To add, change, or disable LazyVim plugins, see:
-- https://www.lazyvim.org/configuration/plugins

return {
  -- add any plugins here
  -- example:
  -- { "folke/flash.nvim", enabled = false }, -- disable flash

  -- colorscheme (tokyonight is default, you can change it)
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}

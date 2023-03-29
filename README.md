# 🔎 Error Lens for Neovim

An enhanced visual diagnostic display for Neovim, inspired by the [Error Lens extension for Visual Studio Code](https://github.com/usernamehw/vscode-error-lens).


# 📸 Showcase
![Showcase of all diagnostic hints](media/error_lens_showcase.png "Showcase of all diagnostic hints")

## ✨ Features

- Easy-to-notice diagnostic messages
- Customizable colors and appearance
- Auto-adjust colors based on the theme color
- Heavily inspired by the Error Lens plugin for Visual Studio Code

## 🚧 Roadmap

- [ ] Togglable hints
- [x] Auto adjust colors based on theme
- [x] Custom colors


## ⚡️ Requirements

- Neovim >= 0.5
- Properly configured Neovim LSP client

## 📦 Installation

Install the plugin with your preferred package manager:

### packer

```lua
-- Lua
use "chikko80/error-lens.nvim"
```

## ⚠️  Caution
This Plugin overrides ```vim.diagnostic.config({})``` by default, since virtual_text must be disable for proper displaying


## ⚙️ Configuration

### Setup
You can configure error-lens.nvim by calling the setup function within an on_attach function of you lsp config.
If you use ```lsp-zero``` check this example :


```lua
local lsp = require('lsp-zero').preset({
    -- preset
})

lsp.ensure_installed({
    'lua_ls',
    'rust_analyzer',
    'solidity',
})

lsp.on_attach(function(client, bufnr)
    require("error-lens").setup(client, {
        -- your config goes here
    })
end)

lsp.setup()

```

VSCODE Info ONedark pro


## Default Options
error-lens.nvim comes with the following default options:


```lua
{
  -- this setting tries to auto adjust the colors 
  -- based on the diagnostic-highlight groups and your 
  -- theme background color with a color blender
  auto_adjust = {
    enable = false,
    theme_bg = nil, -- mandatory if enable true
    step = 5, -- inc: colors should be brighter/darker
    total = 30 -- steps of blender
  },
  disable_vt = true, -- disable vim.diagnostic virtual_text
  prefix = 5, -- distance code <-> diagnostic message
  -- default colors
  colors = {
    error_fg = "#FF6363", -- diagnostic font color
    error_bg = "#4B252C", -- diagnostic line color
    warn_fg = "#FA973A",
    warn_bg = "#403733",
    info_fg = "#5B38E8",
    info_bg = "#281478",
    hint_fg = "#25E64B",
    hint_bg = "#147828"
  }
}
```


## 🚀 Usage
After installing and configuring the plugin, it will automatically enhance the diagnostic display in Neovim.

## ⚠️ Disclaimer:
I recently switched from VsCode to Neovim and really missed that plugin. Therefore i tried to code it myself.
I am not really familiar with Lua, so if you find any bugs please raise an issue.
PRs and improvements or ideas are also welcome.


## 📚 Credits
This plugin is heavily inspired by the [Error Lens extension](https://github.com/usernamehw/vscode-error-lens) for Visual Studio Code.

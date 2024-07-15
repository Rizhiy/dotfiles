# dotfiles/.config/nvim

<a href="https://dotfyle.com/Rizhiy/dotfiles-config-nvim"><img src="https://dotfyle.com/Rizhiy/dotfiles-config-nvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/Rizhiy/dotfiles-config-nvim"><img src="https://dotfyle.com/Rizhiy/dotfiles-config-nvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/Rizhiy/dotfiles-config-nvim"><img src="https://dotfyle.com/Rizhiy/dotfiles-config-nvim/badges/plugin-manager?style=flat" /></a>

## Install Instructions

> Install requires Neovim 0.10+. Always review the code before installing a configuration.

Clone the repository and install the plugins:

```sh
git clone git@github.com:Rizhiy/dotfiles ~/.config/Rizhiy/dotfiles
NVIM_APPNAME=Rizhiy/dotfiles/.config/nvim nvim --headless +"Lazy! sync" +qa
```

Open Neovim with this config:

```sh
NVIM_APPNAME=Rizhiy/dotfiles/.config/nvim nvim
```

## Plugins

### bars-and-lines

- [lukas-reineke/virt-column.nvim](https://dotfyle.com/plugins/lukas-reineke/virt-column.nvim)

### code-runner

- [CRAG666/code_runner.nvim](https://dotfyle.com/plugins/CRAG666/code_runner.nvim)

### color

- [NvChad/nvim-colorizer.lua](https://dotfyle.com/plugins/NvChad/nvim-colorizer.lua)
- [xiyaowong/transparent.nvim](https://dotfyle.com/plugins/xiyaowong/transparent.nvim)

### comment

- [danymat/neogen](https://dotfyle.com/plugins/danymat/neogen)
- [folke/todo-comments.nvim](https://dotfyle.com/plugins/folke/todo-comments.nvim)
- [terrortylor/nvim-comment](https://dotfyle.com/plugins/terrortylor/nvim-comment)

### completion

- [SergioRibera/cmp-dotenv](https://dotfyle.com/plugins/SergioRibera/cmp-dotenv)
- [hrsh7th/nvim-cmp](https://dotfyle.com/plugins/hrsh7th/nvim-cmp)

### cursorline

- [RRethy/vim-illuminate](https://dotfyle.com/plugins/RRethy/vim-illuminate)

### debugging

- [Weissle/persistent-breakpoints.nvim](https://dotfyle.com/plugins/Weissle/persistent-breakpoints.nvim)
- [mfussenegger/nvim-dap](https://dotfyle.com/plugins/mfussenegger/nvim-dap)
- [rcarriga/nvim-dap-ui](https://dotfyle.com/plugins/rcarriga/nvim-dap-ui)
- [theHamsta/nvim-dap-virtual-text](https://dotfyle.com/plugins/theHamsta/nvim-dap-virtual-text)

### dependency-management

- [piersolenski/telescope-import.nvim](https://dotfyle.com/plugins/piersolenski/telescope-import.nvim)

### diagnostics

- [folke/trouble.nvim](https://dotfyle.com/plugins/folke/trouble.nvim)

### editing-support

- [monaqa/dial.nvim](https://dotfyle.com/plugins/monaqa/dial.nvim)
- [windwp/nvim-autopairs](https://dotfyle.com/plugins/windwp/nvim-autopairs)
- [nvim-treesitter/nvim-treesitter-context](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter-context)

### file-explorer

- [stevearc/oil.nvim](https://dotfyle.com/plugins/stevearc/oil.nvim)

### fuzzy-finder

- [nvim-telescope/telescope.nvim](https://dotfyle.com/plugins/nvim-telescope/telescope.nvim)

### git

- [lewis6991/gitsigns.nvim](https://dotfyle.com/plugins/lewis6991/gitsigns.nvim)
- [sindrets/diffview.nvim](https://dotfyle.com/plugins/sindrets/diffview.nvim)

### icon

- [nvim-tree/nvim-web-devicons](https://dotfyle.com/plugins/nvim-tree/nvim-web-devicons)

### indent

- [lukas-reineke/indent-blankline.nvim](https://dotfyle.com/plugins/lukas-reineke/indent-blankline.nvim)

### keybinding

- [folke/which-key.nvim](https://dotfyle.com/plugins/folke/which-key.nvim)

### lsp

- [neovim/nvim-lspconfig](https://dotfyle.com/plugins/neovim/nvim-lspconfig)
- [onsails/lspkind.nvim](https://dotfyle.com/plugins/onsails/lspkind.nvim)
- [nvimtools/none-ls.nvim](https://dotfyle.com/plugins/nvimtools/none-ls.nvim)
- [stevearc/aerial.nvim](https://dotfyle.com/plugins/stevearc/aerial.nvim)

### lsp-installer

- [williamboman/mason.nvim](https://dotfyle.com/plugins/williamboman/mason.nvim)

### lua-colorscheme

- [ellisonleao/gruvbox.nvim](https://dotfyle.com/plugins/ellisonleao/gruvbox.nvim)

### markdown-and-latex

- [toppair/peek.nvim](https://dotfyle.com/plugins/toppair/peek.nvim)
- [jghauser/follow-md-links.nvim](https://dotfyle.com/plugins/jghauser/follow-md-links.nvim)

### marks

- [ThePrimeagen/harpoon](https://dotfyle.com/plugins/ThePrimeagen/harpoon)
- [chentoast/marks.nvim](https://dotfyle.com/plugins/chentoast/marks.nvim)

### motion

- [folke/flash.nvim](https://dotfyle.com/plugins/folke/flash.nvim)

### nvim-dev

- [folke/neodev.nvim](https://dotfyle.com/plugins/folke/neodev.nvim)
- [MunifTanjim/nui.nvim](https://dotfyle.com/plugins/MunifTanjim/nui.nvim)
- [nvim-lua/plenary.nvim](https://dotfyle.com/plugins/nvim-lua/plenary.nvim)

### plugin-manager

- [folke/lazy.nvim](https://dotfyle.com/plugins/folke/lazy.nvim)

### quickfix

- [kevinhwang91/nvim-bqf](https://dotfyle.com/plugins/kevinhwang91/nvim-bqf)

### register

- [tversteeg/registers.nvim](https://dotfyle.com/plugins/tversteeg/registers.nvim)

### search

- [nvim-pack/nvim-spectre](https://dotfyle.com/plugins/nvim-pack/nvim-spectre)

### snippet

- [chrisgrieser/nvim-scissors](https://dotfyle.com/plugins/chrisgrieser/nvim-scissors)
- [rafamadriz/friendly-snippets](https://dotfyle.com/plugins/rafamadriz/friendly-snippets)
- [L3MON4D3/LuaSnip](https://dotfyle.com/plugins/L3MON4D3/LuaSnip)

### startup

- [goolord/alpha-nvim](https://dotfyle.com/plugins/goolord/alpha-nvim)

### statusline

- [nvim-lualine/lualine.nvim](https://dotfyle.com/plugins/nvim-lualine/lualine.nvim)

### syntax

- [nvim-treesitter/nvim-treesitter-textobjects](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter-textobjects)
- [nvim-treesitter/nvim-treesitter](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter)
- [echasnovski/mini.surround](https://dotfyle.com/plugins/echasnovski/mini.surround)

### terminal-integration

- [akinsho/toggleterm.nvim](https://dotfyle.com/plugins/akinsho/toggleterm.nvim)

### utility

- [LintaoAmons/scratch.nvim](https://dotfyle.com/plugins/LintaoAmons/scratch.nvim)
- [folke/noice.nvim](https://dotfyle.com/plugins/folke/noice.nvim)
- [rcarriga/nvim-notify](https://dotfyle.com/plugins/rcarriga/nvim-notify)
- [jghauser/mkdir.nvim](https://dotfyle.com/plugins/jghauser/mkdir.nvim)

## Language Servers

This readme was generated by [Dotfyle](https://dotfyle.com)

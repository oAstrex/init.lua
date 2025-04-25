-- init.lua - Neovim Config

-- ----------------------------
-- Interface
-- ----------------------------
vim.opt.number = true                -- Show line numbers
vim.opt.termguicolors = true         -- Enable 24-bit colors

-- ----------------------------
-- Tabs and Indentation
-- ----------------------------
vim.opt.tabstop = 4                  -- Number of visual spaces per TAB
vim.opt.shiftwidth = 4               -- Spaces used for autoindent
vim.opt.expandtab = true             -- Convert TAB to spaces
vim.opt.smartindent = true           -- Smart auto-indenting on new lines

-- ----------------------------
-- Syntax Highlighting
-- ----------------------------
vim.cmd("syntax on")                 -- Enable syntax highlighting

-- ----------------------------
-- Color scheme settings
-- ----------------------------
-- You can uncomment and set your desired colorscheme here:
-- vim.cmd("colorscheme desert")
-- vim.cmd("colorscheme elflord")
-- vim.cmd("colorscheme gruvbox")

-- Custom highlight tweaks
vim.cmd("highlight Comment ctermfg=DarkGray")
vim.cmd("highlight Normal ctermbg=none")
vim.cmd("highlight Identifier ctermfg=Blue")
vim.cmd("highlight Statement ctermfg=Yellow")

-- ----------------------------
-- Case sensitivity for searches
-- ----------------------------
vim.opt.ignorecase = true           -- Ignore case when searching
vim.opt.smartcase = true            -- Unless the search term contains uppercase
vim.opt.incsearch = true            -- Show matches while typing
vim.opt.hlsearch = true             -- Highlight all matches after searching

-- ----------------------------
-- UI Customization
-- ----------------------------
-- Set background color of main editing area (Normal group)
vim.cmd("highlight Normal ctermbg=Black ctermfg=White")

-- Set background color of line number column (sign column + line numbers)
vim.cmd("highlight LineNr ctermfg=DarkGray ctermbg=DarkBlue")
vim.cmd("highlight CursorLineNr ctermfg=Yellow ctermbg=DarkBlue")

-- Optional: show a darker bar below line numbers (sign column)
vim.cmd("highlight SignColumn ctermbg=DarkBlue")

-- Highlight the line your cursor is on
vim.opt.cursorline = true
vim.cmd("highlight CursorLine ctermbg=DarkGray")

-- ----------------------------
-- Command-line window styling
-- ----------------------------
-- Neovim doesn't natively have VS Code-style popups, but we can tweak visibility
vim.cmd("highlight StatusLine ctermfg=White ctermbg=DarkGray")
vim.cmd("highlight Cmdline ctermfg=Black ctermbg=LightGray")

-- ----------------------------
-- End of Config
-- ----------------------------



-- Lazy Stuff

-- Plugin manager setup (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Popup UI
  "folke/noice.nvim",
  "MunifTanjim/nui.nvim",
  "rcarriga/nvim-notify",
  "nvim-tree/nvim-tree.lua",
  -- LSP setup
  "neovim/nvim-lspconfig",
  -- Completion plugin
  "hrsh7th/nvim-cmp", 
  "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
  "hrsh7th/cmp-buffer",   -- Buffer source for nvim-cmp
  "hrsh7th/cmp-path",     -- Path source for nvim-cmp
})

require('lspconfig').pyright.setup{}

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)  -- For using snippets
    end,
  },
  mapping = {
    ['<S-p>'] = cmp.mapping.select_prev_item(),  -- Shift + P for previous item
    ['<S-n>'] = cmp.mapping.select_next_item(),  -- Shift + N for next item
    ['<S-d>'] = cmp.mapping.scroll_docs(-4),     -- Shift + D to scroll docs up
    ['<S-f>'] = cmp.mapping.scroll_docs(4),      -- Shift + F to scroll docs down
    ['<S-Space>'] = cmp.mapping.complete(),      -- Shift + Space to trigger completion
    ['<S-e>'] = cmp.mapping.close(),             -- Shift + E to close completion
    ['<S-CR>'] = cmp.mapping.confirm({ select = true }), -- Shift + Enter to confirm
  },
  completion = {
    autocomplete = { cmp.TriggerEvent.TextChanged },  -- Automatically trigger completion
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },
})


-- Enable notify
vim.notify = require("notify")

-- Configure noice
require("noice").setup({
  cmdline = {
    enabled = true,           -- enable the VS Code-style command popup
    view = "cmdline_popup",   -- or "cmdline" for inline style
  },
  messages = { enabled = true },
  popupmenu = { enabled = true }, -- enables popup completion menu
  lsp = {
    progress = { enabled = true },
    signature = { enabled = true },
    hover = { enabled = true },
  },
})

-- NvimTree configuration
require("nvim-tree").setup({
  view = {
    width = 30, -- Width of the file explorer
    side = 'left', -- Position of the file explorer (left or right)
  },
  renderer = {
    highlight_opened_files = "all", -- Highlight opened files
  },
})

-- Open/close NvimTree with a keybinding
vim.api.nvim_set_keymap("n", "<S-e>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })


vim.opt.splitright = true

vim.opt.guicursor = {
    "n-v-c:block",      -- Normal/Visual/Command: block
    "i-ci:ver25",       -- Insert/Insert Command: vertical bar (25% height)
    "v:hor20",          -- Visual: horizontal bar (20% height)
    "r-cr:hor20",       -- Replace modes: horizontal bar
    "o:hor20",          -- Operator-pending: horizontal bar
}

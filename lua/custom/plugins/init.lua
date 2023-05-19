-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Miscellaneous plugins
  'danilamihailov/beacon.nvim',
  'github/copilot.vim',

  {
    'folke/twilight.nvim',
    config = function()
      require('twilight').setup()
    end,
  },

  {
    'folke/zen-mode.nvim',
    config = function()
      require('zen-mode').setup {
        plugins = {
          gitsigns = { enabled = true },
          twilight = { enabled = true },
        },
        on_open = function(_)
          vim.o.number = false
        end,
        on_close = function()
          vim.o.number = true
        end,
      }
    end,
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  },

  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {},
  },

  -- Adds git releated signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']g', function()
            if vim.wo.diff then
              return ']g'
            end
            vim.schedule(function()
              gs.next_hunk()
              vim.cmd 'normal! zz'
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'Go to next hunk' })

          map('n', '[g', function()
            if vim.wo.diff then
              return '[g'
            end
            vim.schedule(function()
              gs.preview_hunk()
              vim.cmd 'normal! zz'
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'Go to previous hunk' })

          -- Actions
          map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = 'Stage hunk' })
          map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = 'Reset hunk' })
          map('n', '<leader>hB', gs.stage_buffer, { desc = 'Stage buffer' })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
          map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
          map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
          map('n', '<leader>hb', function()
            gs.blame_line { full = true }
          end, { desc = 'Blame line' })
          map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle blame' })
          map('n', '<leader>hd', gs.diffthis, { desc = 'Diff this' })
          map('n', '<leader>hD', function()
            gs.diffthis '~'
          end, { desc = 'Diff this (cached)' })
          map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle deleted' })
          map('n', '<leader>C', ':10new|:terminal ai-commit<CR>i', { desc = 'Commit' })

          -- Text objects
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
        end,
      }
    end,
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {
        sort_by = 'case_sensitive',
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      }
    end,
  },

  {
    'max397574/better-escape.nvim',
    config = function()
      require('better_escape').setup {
        mapping = { 'jk', 'kj' }, -- a table with mappings to use
        timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
        clear_empty_lines = false, -- clear line after escaping if there is only whitespace
        -- keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
        -- example(recommended)
        keys = function()
          return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
        end,
      }
    end,
  },

  { 'echasnovski/mini.nvim', version = '*' },

  {
    'akinsho/bufferline.nvim',
    version = 'v3.*',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('bufferline').setup()
    end,
  },

  {
    'aserowy/tmux.nvim',
    config = function()
      return require('tmux').setup()
    end,
  },

  {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        log_level = 'error',
        auto_session_suppress_dirs = { '~/', '~/Workspace', '~/Downloads', '/' },
      }
    end,
  },

  {
    'dpayne/CodeGPT.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
    },
  },

  {
    'simrat39/rust-tools.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap',
    },
    config = function()
      require('rust-tools').setup {}
      require('rust-tools').lsp.start_standalone_if_required()
    end,
  },

  {
    'saecki/crates.nvim',
    version = 'v0.3.0',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
    end,
  },

  { 'akinsho/toggleterm.nvim', version = '*', config = true },
}

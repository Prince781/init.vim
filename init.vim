" include vim plugins
" set runtimepath^=/usr/share/vim/vimfiles

call plug#begin()
" basic
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-lua/plenary.nvim'

" completion / snippets
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'petertriho/cmp-git'

" tools
Plug 'kyazdani42/nvim-tree.lua'
Plug 'stevearc/aerial.nvim'
Plug 'dstein64/vim-startuptime'
Plug 'nvim-treesitter/playground'
Plug 'dhruvasagar/vim-table-mode'
Plug 'pwntester/octo.nvim'
Plug 'igankevich/mesonic'
Plug 'lvimuser/lsp-inlayhints.nvim'
Plug 'editorconfig/editorconfig-vim'

" themes
Plug 'agude/vim-eldar'
Plug 'Mofiqul/adwaita.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'nvim-lualine/lualine.nvim'

" file types
Plug 'rhysd/vim-llvm'
Plug 'vala-lang/vala.vim'
Plug 'shiracamus/vim-syntax-x86-objdump-d'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" version control
Plug 'tpope/vim-fugitive'
Plug 'ngemily/vim-vp4'

" font icons
Plug 'kyazdani42/nvim-web-devicons'
call plug#end()

set tabstop=8 softtabstop=0 shiftwidth=4 smarttab smartindent

" by default, use spaced tabs
set expandtab

" Enable mouse interaction
set mouse=a
set mousemodel=popup

set completeopt=menu,menuone,noselect

" show line numbers
set number

" colo adwaita
" colo peachpuff

" see https://unix.stackexchange.com/questions/63196/in-vim-how-can-i-automatically-determine-whether-to-use-spaces-or-tabs-for-inde
function TabsOrSpaces()
    " Determines whether to use spaces or tabs on the current buffer.
    if getfsize(bufname("%")) > 256000
        " File is very large, just use the default.
        return
    endif

    let numTabs=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^\\t"'))
    let numSpaces=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^ "'))

    if numTabs > numSpaces
        setlocal noexpandtab
    endif
endfunction

" Call the function after opening a buffer to determine whether to use tabs or
" spaces
autocmd BufReadPost * call TabsOrSpaces()

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "bash", "c", "cpp", "cuda", "lua", "python", "vala", "vim" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  -- sync_install = false,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    -- additional_vim_regex_highlighting = false,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    }
  }
}

-- LSP Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- telescope setup
require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        -- ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
        },
        ["n"] = {
        },
      }
    }
  }
}

-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function
require('telescope').load_extension 'file_browser'

-- vim.api.nvim_set_keymap('n', '<space>fb', ':Telescope file_browser', { noremap = true })
vim.keymap.set('n', '<space>fb', require('telescope').extensions.file_browser.file_browser, opts)

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<space>d', telescope.diagnostics, opts)
vim.keymap.set('n', '<space>sw', telescope.lsp_dynamic_workspace_symbols, opts)
vim.keymap.set('n', '<space>sd', telescope.lsp_document_symbols, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', telescope.lsp_definitions, bufopts)
  vim.keymap.set('n', 'gT', telescope.lsp_type_definitions, bufopts)
  vim.keymap.set('n', 'gci', telescope.lsp_incoming_calls, bufopts)
  vim.keymap.set('n', 'gco', telescope.lsp_outgoing_calls, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  -- local telescope = require('telescope.builtin')
  vim.keymap.set('n', 'gi', telescope.lsp_implementations, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gr', telescope.lsp_references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'vsnip' },
    { name = 'path' },
    -- { name = 'cmdline' },
    -- { name = 'buffer' },
    { name = 'git' },
  },
}

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local capabilities = require('cmp_nvim_lsp')
    .default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.completion.completionItem.resolveSupport = {
--   properties = {
--     'documentation',
--     'detail',
--     'additionalTextEdits',
--   }
-- }

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'bashls', 'clangd', 'lua_ls', 'ocamlls', 'pyright', 'rust_analyzer', 'tsserver', 'vimls', 'yamlls' }
local nvim_lsp = require('lspconfig')
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities
  }
end

require 'lspconfig'.vala_ls.setup {
--  cmd = { 'env', 'G_MESSAGES_DEBUG=all', 'JSONRPC_DEBUG=1', 'vala-language-server'},
--  cmd = {'env', 'G_MESSAGES_DEBUG=all', 'vala-language-server'},
--  cmd = { 'env', 'G_MESSAGES_DEBUG=all', 'valgrind', '--vgdb=yes', '--vgdb-error=0', 'vala-language-server'},
--  cmd = { 'env', 'G_MESSAGES_DEBUG=all', 'rr', 'record', 'vala-language-server'},
--  cmd = { 'valgrind', '--leak-check=summary', 'vala-language-server'},
  cmd = {'vala-language-server'},
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities
}

require'lspconfig'.jsonls.setup {
  cmd = { 'vscode-json-languageserver', '--stdio' },
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities
}

-- aerial
require('aerial').setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
  end
})
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')

-- nvim-tree
require('nvim-tree').setup{
  diagnostics = {
    enable = true,
    show_on_dirs = true
  }
}

-- nvim-web-devicons
require('nvim-web-devicons').setup{}

-- octo
require('octo').setup({
  default_remote = {"upstream", "origin"}; -- order to try remotes
  ssh_aliases = {},                        -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
  reaction_viewer_hint_icon = "";         -- marker for user reactions
  user_icon = " ";                        -- user icon
  timeline_marker = "";                   -- timeline marker
  timeline_indent = "2";                   -- timeline indentation
  right_bubble_delimiter = "";            -- Bubble delimiter
  left_bubble_delimiter = "";             -- Bubble delimiter
  github_hostname = "";                    -- GitHub Enterprise host
  snippet_context_lines = 4;               -- number or lines around commented lines
  file_panel = {
    size = 10,                             -- changed files panel rows
    use_icons = true                       -- use web-devicons in file panel (if false, nvim-web-devicons does not need to be installed)
  }
})

require('cmp_git').setup{}

-- inlay hints
require('lsp-inlayhints').setup{}
vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlayhints",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require("lsp-inlayhints").on_attach(client, bufnr)
  end,
})

-- themes (gruvbox)
-- setup must be called before loading the colorscheme
-- Default options:
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = true,
})
vim.cmd("colorscheme gruvbox")

require('lualine').setup{}
EOF

" LSP
" -- document highlight
autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()

" vsnip
" -- Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" -- Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" -- Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Telescope
" -- Miscellaneous Pickers
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fm <cmd>lua require('telescope.builtin').man_pages({sections = {'ALL'}})<cr>
nnoremap <leader>ft <cmd>lua require('telescope.builtin').tags()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').command_history()<cr>
nnoremap <leader>fj <cmd>lua require('telescope.builtin').jumplist()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').resume()<cr>
nnoremap <leader>fp <cmd>lua require('telescope.builtin').pickers()<cr>

" -- Git Pickers
nnoremap <leader>gc <cmd>lua require('telescope.builtin').git_commits()<cr>
nnoremap <leader>gb <cmd>lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>gs <cmd>lua require('telescope.builtin').git_stash()<cr>

" -- Octo Pickers
" --- Repository
nnoremap <leader>orb <cmd>Octo repo browser<cr>
nnoremap <leader>oru <cmd>Octo repo url<cr>
" --- Pull Requests
nnoremap <leader>opl <cmd>Octo pr list<cr>
nnoremap <leader>opb <cmd>Octo pr browser<cr>
nnoremap <leader>opc <cmd>Octo pr checkout<cr>
nnoremap <leader>opd <cmd>Octo pr diff<cr>
nnoremap <leader>opm <cmd>Octo pr merge rebase<cr>
" --- Issues
nnoremap <leader>oil <cmd>Octo issue list<cr>
nnoremap <leader>ois <cmd>Octo issue search<cr>
nnoremap <leader>oib <cmd>Octo issue browser<cr>
nnoremap <leader>oiu <cmd>Octo issue url<cr>

" NVIM Tree Toggle
nnoremap <leader>t <cmd>NvimTreeToggle<cr>

" Toggle background
nnoremap <leader>bd <cmd>set background=dark<cr>
nnoremap <leader>bl <cmd>set background=light<cr>

" Git
nnoremap <leader>Ga <cmd>Git add %<cr>
nnoremap <leader>Gb <cmd>Git blame<cr>
nnoremap <leader>Gd <cmd>Git diff<cr>
nnoremap <leader>Gf <cmd>Git fetch -ap<cr>
nnoremap <leader>Gl <cmd>Git log<cr>
nnoremap <leader>Gp <cmd>Git pull --rebase<cr>
nnoremap <leader>Gr <cmd>Git restore --staged %<cr>
nnoremap <leader>Gs <cmd>Git status<cr>

" Open VIMRC
nnoremap <leader>v <cmd>e $MYVIMRC<cr>
" Reload VIMRC
nnoremap <leader>r <cmd>so $MYVIMRC<cr>
" Quit
nnoremap <leader>q <cmd>q<cr>

" Vim Plug
nnoremap <leader>Pu <cmd>PlugUpdate<cr>
nnoremap <leader>Ch <cmd>CheckHealth<cr>

" Automatically update copyright notice with current year
" see https://vim.fandom.com/wiki/Automatically_Update_Copyright_Notice_in_Files
" autocmd BufWritePre *
"   \ if &modified |
"   \   exe '%s:'.
"   \       '\cCOPYRIGHT\s*\%((c)\|©\|&copy;\)\?\s*'.
"   \         '\%([0-9]\{4}\(-[0-9]\{4\}\)\?,\s*\)*\zs'.
"   \         '\('.
"   \           '\%('.strftime("%Y").'\)\@![0-9]\{4\}'.
"   \           '\%(-'.strftime("%Y").'\)\@!\%(-[0-9]\{4\}\)\?'.
"   \         '\&'.
"   \           '\%([0-9]\{4\}-\)\?'.
"   \           '\%('.(strftime("%Y")-1).'\)\@!'.
"   \           '\%([0-9]\)\{4\}'.
"   \         '\)'.
"   \         '\ze\%(\%([0-9]\{4\}\)\@!.\)*$:'.
"   \       '&, '.strftime("%Y").':e' |
"   \   exe '%s:'.
"   \       '\cCOPYRIGHT\s*\%((c)\|©\|&copy;\)\?\s*'.
"   \         '\%([0-9]\{4}\%(-[0-9]\{4\}\)\?,\s*\)*\zs'.
"   \           '\%('.strftime("%Y").'\)\@!\([0-9]\{4\}\)'.
"   \           '\%(-'.strftime("%Y").'\)\@!\%(-[0-9]\{4\}\)\?'.
"   \         '\ze\%(\%([0-9]\{4\}\)\@!.\)*$:'.
"   \       '\1-'.strftime("%Y").':e' |
"   \ endif

" For dhruvasagar/vim-table-mode
let g:table_mode_corner='|'

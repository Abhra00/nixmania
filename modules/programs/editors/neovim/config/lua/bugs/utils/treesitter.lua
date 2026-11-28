local M = {}

-- Prepending the nvim-treesitter runtime shadows Neovim's bundled queries for every language, not only the listed ones
-- Those queries track nvim-treesitter's parser revisions, so bundled parsers must be installed through it too
-- Otherwise parsers and queries drift apart and highlighting breaks
function M.install_list()
  local parsers = {
    "bash",
    "c",
    "cpp",
    "css",
    "fish",
    "gitcommit",
    "go",
    "graphql",
    "html",
    "hyprlang",
    "java",
    "javascript",
    "json",
    "json5",
    "lua",
    "markdown",
    "markdown_inline",
    "nix",
    "python",
    "query",
    "rasi",
    "regex",
    "rust",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  }

  local set = {}
  for _, parser in ipairs(parsers) do
    set[parser] = true
  end

  local site = vim.fn.stdpath("data")
  for _, path in ipairs(vim.api.nvim_get_runtime_file("parser/*", true)) do
    -- Skip the parsers nvim-treesitter already installed under the site directory
    if not vim.startswith(path, site) then
      set[vim.fn.fnamemodify(path, ":t:r")] = true
    end
  end

  return vim.tbl_keys(set)
end

return M

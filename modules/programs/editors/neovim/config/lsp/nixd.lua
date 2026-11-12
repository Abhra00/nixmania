-- Nix language server

-- Dynamically find the project root containing flake.nix or .git
local root_dir = vim.fs.root(0, { "flake.nix", ".git" }) or vim.fn.getcwd()
local flake = string.format('(builtins.getFlake "file://%s")', root_dir)

-- Dynamically fetch the current machine's hostname
local host = vim.uv.os_gethostname() or vim.fn.hostname()

---@type vim.lsp.Config
return {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", ".git" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = string.format("import %s.inputs.nixpkgs { }", flake),
      },
      options = {
        nixos = {
          expr = string.format("%s.nixosConfigurations.%s.options", flake, host),
        },
        ["home-manager"] = {
          expr = string.format(
            "%s.nixosConfigurations.%s.options.home-manager.users.type.getSubOptions []",
            flake,
            host
          ),
        },
      },
    },
  },
}

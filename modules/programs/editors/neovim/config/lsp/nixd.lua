-- Nix language server

local flake = string.format('(builtins.getFlake "%s")', vim.fn.expand("~/nixmania"))
local host = "TR-100-machine"

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

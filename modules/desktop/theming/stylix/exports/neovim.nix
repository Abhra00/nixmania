{
  flake.modules.nixos.editor_neovim = {
    config,
    lib,
    pkgs,
    inputs,
    ...
  }: let
    cfg = config.stylix.enable or false;
    stx = config.lib.stylix.colors.withHashtag;
    math = import "${inputs.self}/lib/math.nix" {inherit lib;};
    hsluv = import "${inputs.self}/lib/hsluv.nix" {inherit lib math;};

    brightAmount = 0.26;

    redSubtleAmount = 0.24;
    greenSubtleAmount = 0.18;
    yellowSubtleAmount = 0.12;
    blueSubtleAmount = 0.15;

    blueMutedSat = -0.35;
    blueMutedDark = 0.35;
    magentaMutedSat = -0.50;
    magentaMutedDark = 0.40;
    magentaAccentSat = 0.85;
    magentaAccentDark = 0.18;
    cyanAccentSat = 1.00;
    cyanAccentDark = 0.05;

    commentHueShift = 28.5;
    commentSat = -0.42;
    commentDark = 0.16;

    colors = with stx; rec {
      bg = base00;
      bg_alt = base01;
      bg_selection = base02;
      bg_visual = "#${hsluv.lighten base01 0.15}";

      comment = "#${hsluv.darken (hsluv.saturate (hsluv.rotateHue base0D commentHueShift) commentSat) commentDark}";
      nontext = "#${hsluv.lighten base03 0.20}";
      fg_gutter = base04;
      fg_muted = "#${hsluv.mix base04 base05 0.5}";
      fg = base05;
      fg_bright = base06;
      fg_brightest = base07;

      black = "#000000";
      white = fg;

      red = base08;
      orange = base09;
      yellow = base0A;
      green = base0B;
      cyan = base0C;
      blue = base0D;
      magenta = base0E;
      brown = base0F;

      bright_red = "#${hsluv.lighten base08 brightAmount}";
      bright_green = "#${hsluv.lighten base0B brightAmount}";
      bright_yellow = "#${hsluv.lighten base0A brightAmount}";
      bright_blue = "#${hsluv.lighten base0D brightAmount}";
      bright_magenta = "#${hsluv.lighten base0E brightAmount}";
      bright_cyan = "#${hsluv.lighten base0C brightAmount}";
      bright_white = fg_brightest;

      magenta_accent = "#${hsluv.darken (hsluv.saturate base0E magentaAccentSat) magentaAccentDark}";
      cyan_accent = "#${hsluv.darken (hsluv.saturate base0C cyanAccentSat) cyanAccentDark}";
      blue_muted = "#${hsluv.darken (hsluv.saturate base0D blueMutedSat) blueMutedDark}";
      magenta_muted = "#${hsluv.darken (hsluv.saturate base0E magentaMutedSat) magentaMutedDark}";

      red_subtle = "#${hsluv.mixRGB base00 base08 redSubtleAmount}";
      green_subtle = "#${hsluv.mixRGB base00 base0B greenSubtleAmount}";
      yellow_subtle = "#${hsluv.mixRGB base00 base0A yellowSubtleAmount}";
      blue_subtle = "#${hsluv.mixRGB base00 base0D blueSubtleAmount}";
    };

    colorschemeLua = ''
      vim.cmd.highlight 'clear'
      if vim.fn.exists 'syntax_on' then
          vim.cmd.syntax 'reset'
      end
      vim.o.termguicolors = true
      vim.g.colors_name = 'stylix'

      local colors = {
          bg            = '${colors.bg}',
          bg_alt        = '${colors.bg_alt}',
          bg_selection  = '${colors.bg_selection}',
          bg_visual     = '${colors.bg_visual}',
          comment       = '${colors.comment}',
          nontext       = '${colors.nontext}',
          fg_gutter     = '${colors.fg_gutter}',
          fg_muted      = '${colors.fg_muted}',
          fg            = '${colors.fg}',
          fg_bright     = '${colors.fg_bright}',
          fg_brightest  = '${colors.fg_brightest}',
          black         = '${colors.black}',
          white         = '${colors.white}',
          red           = '${colors.red}',
          orange        = '${colors.orange}',
          yellow        = '${colors.yellow}',
          green         = '${colors.green}',
          cyan          = '${colors.cyan}',
          blue          = '${colors.blue}',
          magenta       = '${colors.magenta}',
          brown         = '${colors.brown}',
          bright_red     = '${colors.bright_red}',
          bright_green   = '${colors.bright_green}',
          bright_yellow  = '${colors.bright_yellow}',
          bright_blue    = '${colors.bright_blue}',
          bright_magenta = '${colors.bright_magenta}',
          bright_cyan    = '${colors.bright_cyan}',
          bright_white   = '${colors.bright_white}',
          magenta_accent = '${colors.magenta_accent}',
          cyan_accent    = '${colors.cyan_accent}',
          blue_muted     = '${colors.blue_muted}',
          magenta_muted  = '${colors.magenta_muted}',
          red_subtle    = '${colors.red_subtle}',
          green_subtle  = '${colors.green_subtle}',
          yellow_subtle = '${colors.yellow_subtle}',
          blue_subtle   = '${colors.blue_subtle}',
      }

      -- Terminal colors.
      vim.g.terminal_color_0  = colors.bg_alt
      vim.g.terminal_color_1  = colors.red
      vim.g.terminal_color_2  = colors.green
      vim.g.terminal_color_3  = colors.yellow
      vim.g.terminal_color_4  = colors.blue
      vim.g.terminal_color_5  = colors.magenta
      vim.g.terminal_color_6  = colors.cyan
      vim.g.terminal_color_7  = colors.fg
      vim.g.terminal_color_8  = colors.selection
      vim.g.terminal_color_9  = colors.bright_red
      vim.g.terminal_color_10 = colors.bright_green
      vim.g.terminal_color_11 = colors.bright_yellow
      vim.g.terminal_color_12 = colors.bright_blue
      vim.g.terminal_color_13 = colors.bright_magenta
      vim.g.terminal_color_14 = colors.bright_cyan
      vim.g.terminal_color_15 = colors.bright_white
      vim.g.terminal_color_background = colors.bg
      vim.g.terminal_color_foreground = colors.fg

      -- Groups used for my statusline.
      ---@type table<string, vim.api.keyset.highlight>
      local statusline_groups = {}
      for mode, color in pairs {
          Normal = 'blue',
          Pending = 'magenta',
          Visual = 'yellow',
          Insert = 'green',
          Command = 'cyan',
          Other = 'orange',
      } do
          statusline_groups['StatuslineMode' .. mode] = { fg = colors.bg_alt, bg = colors[color] }
          statusline_groups['StatuslineModeSeparator' .. mode] = { fg = colors[color], bg = colors.bg_alt }
      end
      statusline_groups = vim.tbl_extend('error', statusline_groups, {
          StatuslineItalic = { fg = colors.fg_muted, bg = colors.bg_alt, italic = true },
          StatuslineSpinner = { fg = colors.bright_green, bg = colors.bg_alt, bold = true },
          StatuslineTitle = { fg = colors.bright_white, bg = colors.bg_alt, bold = true },
      })

      ---@type table<string, vim.api.keyset.highlight>
      local groups = vim.tbl_extend('error', statusline_groups, {
          -- Builtins.
          Boolean = { fg = colors.cyan },
          Character = { fg = colors.green },
          ColorColumn = { bg = colors.bg_selection },
          Comment = { fg = colors.comment, italic = true },
          Conceal = { fg = colors.comment },
          Conditional = { fg = colors.magenta },
          Constant = { fg = colors.yellow },
          CurSearch = { fg = colors.black, bg = colors.magenta_accent },
          Cursor = { fg = colors.black, bg = colors.white },
          CursorColumn = { bg = colors.bg_alt },
          CursorLine = { bg = colors.bg_selection },
          CursorLineNr = { fg = colors.magenta_muted, bold = true },
          Define = { fg = colors.blue },
          Directory = { fg = colors.cyan },
          EndOfBuffer = { fg = colors.bg },
          Error = { fg = colors.bright_red },
          ErrorMsg = { fg = colors.bright_red },
          FoldColumn = {},
          Folded = { bg = colors.bg_alt },
          Function = { fg = colors.yellow },
          Identifier = { fg = colors.cyan },
          IncSearch = { link = 'CurSearch' },
          Include = { fg = colors.blue },
          Keyword = { fg = colors.cyan },
          Label = { fg = colors.cyan },
          LineNr = { fg = colors.magenta_muted },
          Macro = { fg = colors.blue },
          MatchParen = { fg = colors.red, bg = colors.red_subtle, sp = colors.red, underline = true },
          NonText = { fg = colors.nontext },
          Normal = { fg = colors.fg, bg = colors.bg },
          NormalFloat = { fg = colors.fg, bg = colors.bg },
          Number = { fg = colors.orange },
          Pmenu = { fg = colors.white, bg = colors.bg },
          PmenuSbar = { bg = colors.blue_subtle },
          PmenuSel = { fg = colors.cyan, bg = colors.bg_selection },
          PmenuThumb = { bg = colors.bg_selection },
          PreCondit = { fg = colors.cyan },
          PreProc = { fg = colors.yellow },
          Question = { fg = colors.blue },
          Repeat = { fg = colors.magenta },
          Search = { fg = colors.bg, bg = colors.orange },
          SignColumn = { bg = colors.bg },
          Special = { fg = colors.green, italic = true },
          SpecialComment = { fg = colors.comment, italic = true },
          SpecialKey = { fg = colors.nontext },
          SpellBad = { sp = colors.bright_red, underline = true },
          SpellCap = { sp = colors.yellow, underline = true },
          SpellLocal = { sp = colors.yellow, underline = true },
          SpellRare = { sp = colors.yellow, underline = true },
          Statement = { fg = colors.blue },
          StatusLine = { fg = colors.white, bg = colors.bg_alt },
          StorageClass = { fg = colors.magenta },
          Structure = { fg = colors.yellow },
          Substitute = { fg = colors.magenta_accent, bg = colors.orange, bold = true },
          Title = { fg = colors.cyan },
          Todo = { fg = colors.blue, bold = true, italic = true },
          Type = { fg = colors.cyan },
          TypeDef = { fg = colors.yellow },
          Underlined = { fg = colors.cyan, underline = true },
          VertSplit = { fg = colors.white },
          Visual = { bg = colors.bg_visual },
          VisualNOS = { fg = colors.bg_visual },
          WarningMsg = { fg = colors.yellow },
          WildMenu = { fg = colors.bg_alt, bg = colors.white },

          -- Treesitter.
          ['@annotation'] = { fg = colors.yellow },
          ['@attribute'] = { fg = colors.cyan },
          ['@boolean'] = { fg = colors.blue },
          ['@character'] = { fg = colors.green },
          ['@constant'] = { fg = colors.blue },
          ['@constant.builtin'] = { fg = colors.blue },
          ['@constant.macro'] = { fg = colors.cyan },
          ['@constructor'] = { fg = colors.cyan },
          ['@error'] = { fg = colors.bright_red },
          ['@function'] = { fg = colors.green },
          ['@function.builtin'] = { fg = colors.cyan },
          ['@function.macro'] = { fg = colors.green },
          ['@function.method'] = { fg = colors.green },
          ['@keyword'] = { fg = colors.magenta },
          ['@keyword.conditional'] = { fg = colors.magenta },
          ['@keyword.exception'] = { fg = colors.blue },
          ['@keyword.function'] = { fg = colors.cyan },
          ['@keyword.function.ruby'] = { fg = colors.magenta },
          ['@keyword.include'] = { fg = colors.magenta },
          ['@keyword.operator'] = { fg = colors.magenta },
          ['@keyword.repeat'] = { fg = colors.magenta },
          ['@label'] = { fg = colors.cyan },
          ['@markup'] = { fg = colors.orange },
          ['@markup.emphasis'] = { fg = colors.yellow, italic = true },
          ['@markup.heading'] = { fg = colors.magenta, bold = true },
          ['@markup.link'] = { fg = colors.orange, bold = true },
          ['@markup.link.uri'] = { fg = colors.yellow, italic = true },
          ['@markup.list'] = { fg = colors.cyan },
          ['@markup.raw'] = { fg = colors.yellow },
          ['@markup.strong'] = { fg = colors.orange, bold = true },
          ['@markup.underline'] = { fg = colors.orange },
          ['@module'] = { fg = colors.orange },
          ['@number'] = { fg = colors.blue },
          ['@number.float'] = { fg = colors.green },
          ['@operator'] = { fg = colors.magenta },
          ['@parameter.reference'] = { fg = colors.orange },
          ['@property'] = { fg = colors.blue },
          ['@punctuation.bracket'] = { fg = colors.fg },
          ['@punctuation.delimiter'] = { fg = colors.fg },
          ['@string'] = { fg = colors.yellow },
          ['@string.escape'] = { fg = colors.cyan },
          ['@string.regexp'] = { fg = colors.bright_red },
          ['@string.special.symbol'] = { fg = colors.blue },
          ['@structure'] = { fg = colors.blue },
          ['@tag'] = { fg = colors.cyan },
          ['@tag.attribute'] = { fg = colors.green },
          ['@tag.delimiter'] = { fg = colors.cyan },
          ['@type'] = { fg = colors.bright_cyan },
          ['@type.builtin'] = { fg = colors.cyan, italic = true },
          ['@type.qualifier'] = { fg = colors.magenta },
          ['@variable'] = { fg = colors.fg },
          ['@variable.builtin'] = { fg = colors.blue },
          ['@variable.member'] = { fg = colors.orange },
          ['@variable.parameter'] = { fg = colors.orange },

          -- Semantic tokens.
          ['@class'] = { fg = colors.cyan },
          ['@decorator'] = { fg = colors.cyan },
          ['@enum'] = { fg = colors.cyan },
          ['@enumMember'] = { fg = colors.blue },
          ['@event'] = { fg = colors.cyan },
          ['@interface'] = { fg = colors.cyan },
          ['@lsp.type.class'] = { fg = colors.cyan },
          ['@lsp.type.decorator'] = { fg = colors.green },
          ['@lsp.type.enum'] = { fg = colors.cyan },
          ['@lsp.type.enumMember'] = { fg = colors.blue },
          ['@lsp.type.function'] = { fg = colors.green },
          ['@lsp.type.interface'] = { fg = colors.cyan },
          ['@lsp.type.macro'] = { fg = colors.cyan },
          ['@lsp.type.method'] = { fg = colors.green },
          ['@lsp.type.namespace'] = { fg = colors.orange },
          ['@lsp.type.parameter'] = { fg = colors.orange },
          ['@lsp.type.property'] = { fg = colors.blue },
          ['@lsp.type.struct'] = { fg = colors.cyan },
          ['@lsp.type.type'] = { fg = colors.bright_cyan },
          ['@lsp.type.variable'] = { fg = colors.fg },
          ['@modifier'] = { fg = colors.cyan },
          ['@regexp'] = { fg = colors.yellow },
          ['@struct'] = { fg = colors.cyan },
          ['@typeParameter'] = { fg = colors.cyan },

          -- LSP.
          ComplHint = { link = 'Comment' },
          DiagnosticDeprecated = { strikethrough = true, fg = colors.fg },
          DiagnosticError = { fg = colors.red },
          DiagnosticFloatingError = { fg = colors.red },
          DiagnosticFloatingHint = { fg = colors.cyan },
          DiagnosticFloatingInfo = { fg = colors.cyan },
          DiagnosticFloatingWarn = { fg = colors.yellow },
          DiagnosticHint = { fg = colors.cyan },
          DiagnosticInfo = { fg = colors.cyan },
          DiagnosticUnderlineError = { undercurl = true, sp = colors.red },
          DiagnosticUnderlineHint = { undercurl = true, sp = colors.cyan },
          DiagnosticUnderlineInfo = { undercurl = true, sp = colors.cyan },
          DiagnosticUnderlineWarn = { undercurl = true, sp = colors.yellow },
          DiagnosticUnnecessary = { fg = colors.fg_muted, italic = true },
          DiagnosticVirtualTextError = { fg = colors.red, bg = colors.red_subtle },
          DiagnosticVirtualTextHint = { fg = colors.cyan, bg = colors.blue_subtle },
          DiagnosticVirtualTextInfo = { fg = colors.cyan, bg = colors.blue_subtle },
          DiagnosticVirtualTextWarn = { fg = colors.yellow, bg = colors.yellow_subtle },
          DiagnosticWarn = { fg = colors.yellow },
          LspCodeLens = { fg = colors.cyan, underline = true },
          LspInlayHint = { fg = colors.blue_muted, italic = true },
          LspReferenceRead = { bg = colors.blue_subtle },
          LspReferenceText = {},
          LspReferenceWrite = { bg = colors.red_subtle },
          LspSignatureActiveParameter = { bold = true, underline = true, sp = colors.fg },

          -- Completions.
          BlinkCmpKindClass = { link = '@type' },
          BlinkCmpKindColor = { link = 'DevIconCss' },
          BlinkCmpKindConstant = { link = '@constant' },
          BlinkCmpKindConstructor = { link = '@type' },
          BlinkCmpKindEnum = { link = '@variable.member' },
          BlinkCmpKindEnumMember = { link = '@variable.member' },
          BlinkCmpKindEvent = { link = '@constant' },
          BlinkCmpKindField = { link = '@variable.member' },
          BlinkCmpKindFile = { link = 'Directory' },
          BlinkCmpKindFolder = { link = 'Directory' },
          BlinkCmpKindFunction = { link = '@function' },
          BlinkCmpKindInterface = { link = '@type' },
          BlinkCmpKindKeyword = { link = '@keyword' },
          BlinkCmpKindMethod = { link = '@function.method' },
          BlinkCmpKindModule = { link = '@module' },
          BlinkCmpKindOperator = { link = '@operator' },
          BlinkCmpKindProperty = { link = '@property' },
          BlinkCmpKindReference = { link = '@parameter.reference' },
          BlinkCmpKindSnippet = { link = '@markup' },
          BlinkCmpKindStruct = { link = '@structure' },
          BlinkCmpKindText = { link = '@markup' },
          BlinkCmpKindTypeParameter = { link = '@variable.parameter' },
          BlinkCmpKindUnit = { link = '@variable.member' },
          BlinkCmpKindValue = { link = '@variable.member' },
          BlinkCmpKindVariable = { link = '@variable' },
          BlinkCmpLabelDeprecated = { link = 'DiagnosticDeprecated' },
          BlinkCmpLabelDescription = { fg = colors.fg_muted, italic = true },
          BlinkCmpLabelDetail = { fg = colors.fg_muted, bg = colors.bg },
          BlinkCmpMenu = { bg = colors.bg },
          BlinkCmpMenuBorder = { bg = colors.bg },

          -- Dap UI.
          DapStoppedLine = { default = true, link = 'Visual' },
          NvimDapVirtualText = { fg = colors.blue_muted, underline = true },

          -- Diffs.
          DiffAdd = { fg = colors.green, bg = colors.green_subtle },
          DiffChange = { fg = colors.white, bg = colors.yellow_subtle },
          DiffDelete = { fg = colors.red, bg = colors.red_subtle },
          DiffText = { fg = colors.orange, bg = colors.yellow_subtle, bold = true },
          DiffviewFolderSign = { fg = colors.cyan },
          DiffviewNonText = { fg = colors.magenta_muted },
          diffAdded = { fg = colors.bright_green, bold = true },
          diffChanged = { fg = colors.bright_yellow, bold = true },
          diffRemoved = { fg = colors.bright_red, bold = true },

          -- Command line.
          MoreMsg = { fg = colors.bright_white, bold = true },
          MsgArea = { fg = colors.cyan },
          MsgSeparator = { fg = colors.magenta_muted },

          -- Winbar styling.
          WinBar = { fg = colors.fg, bg = colors.bg_alt },
          WinBarNC = { bg = colors.bg_alt },
          WinBarDir = { fg = colors.bright_magenta, bg = colors.bg_alt, italic = true },
          WinBarSeparator = { fg = colors.green, bg = colors.bg_alt },

          -- Quickfix window.
          QuickFixLine = { italic = true, bg = colors.red_subtle },

          -- Gitsigns.
          GitSignsAdd = { fg = colors.bright_green },
          GitSignsChange = { fg = colors.cyan },
          GitSignsCurrentLineBlame = { fg = colors.blue_muted },
          GitSignsDelete = { fg = colors.bright_red },
          GitSignsStagedAdd = { fg = colors.orange },
          GitSignsStagedChange = { fg = colors.orange },
          GitSignsStagedDelete = { fg = colors.orange },

          -- Gitlinker.
          NvimGitLinkerHighlightTextObject = { link = 'Visual' },

          -- Bufferline.
          BufferLineBufferSelected = { bg = colors.bg, underline = true, sp = colors.blue },
          BufferLineFill = { bg = colors.bg },
          TabLine = { fg = colors.comment, bg = colors.bg },
          TabLineFill = { bg = colors.bg },
          TabLineSel = { bg = colors.blue },

          -- When triggering flash, use a white font and make everything in the backdrop italic.
          FlashBackdrop = { italic = true },
          FlashPrompt = { link = 'Normal' },

          -- Make these titles more visible.
          MiniClueTitle = { bold = true, fg = colors.cyan },
          MiniFilesTitleFocused = { bold = true, fg = colors.cyan },

          -- Nicer yanky highlights.
          YankyPut = { link = 'Visual' },
          YankyYanked = { link = 'Visual' },

          -- Highlight for the Treesitter sticky context.
          TreesitterContextBottom = { underline = true, sp = colors.magenta_muted },

          -- Fzf overrides.
          FzfLuaBorder = { fg = colors.comment },
          FzfLuaHeaderBind = { fg = colors.blue_muted },
          FzfLuaHeaderText = { fg = colors.magenta },
          FzfLuaLivePrompt = { link = 'Normal' },
          FzfLuaLiveSym = { fg = colors.magenta_accent },
          FzfLuaPreviewTitle = { fg = colors.fg },
          FzfLuaSearch = { bg = colors.red_subtle },

          -- Nicer sign column highlights for grug-far.
          GrugFarResultsChangeIndicator = { link = 'Changed' },
          GrugFarResultsRemoveIndicator = { link = 'Removed' },
          GrugFarResultsAddIndicator = { link = 'Added' },

          -- Links.
          HighlightUrl = { underline = true, fg = colors.cyan_accent, sp = colors.cyan_accent },

          -- AI completions.
          NeoCodeiumSuggestion = { link = 'Comment' },
      })

      for group, opts in pairs(groups) do
          vim.api.nvim_set_hl(0, group, opts)
      end
    '';
  in {
    hm.xdg.configFile."nvim/colors/stylix.lua" = lib.mkIf cfg {
      source = pkgs.writeText "stylix-colorscheme.lua" colorschemeLua;
    };
  };
}

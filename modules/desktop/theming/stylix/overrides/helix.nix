{
  flake.modules.nixos.editor_helix = {
    config,
    lib,
    ...
  }: let
    cfg = config.stylix.enable or false;
    stx = config.lib.stylix.colors.withHashtag;

    math = import ../../../../../lib/math.nix {inherit lib;};
    hsluv = import ../../../../../lib/hsluv.nix {inherit lib math;};

    # derived — output is bare hex
    l = hex: hsluv.lighten hex;

    highlight_low = l stx.base00 0.08;
    highlight_med = l stx.base02 0.10;
    highlight_high = l stx.base02 0.22;

    base08_15 = hsluv.mixRGB stx.base00 stx.base08 0.15;
    base09_15 = hsluv.mixRGB stx.base00 stx.base09 0.15;
    base0A_15 = hsluv.mixRGB stx.base00 stx.base0A 0.15;
    base0B_15 = hsluv.mixRGB stx.base00 stx.base0B 0.15;
    base0C_15 = hsluv.mixRGB stx.base00 stx.base0C 0.15;
    base0D_15 = hsluv.mixRGB stx.base00 stx.base0D 0.15;
  in {
    hm.programs.helix.settings.theme = lib.mkIf cfg "stylix";

    hm.xdg.configFile."helix/themes/stylix.toml".text =
      lib.mkIf cfg
      (with stx; ''
        # ┳┳┳
        # ┃┃┃
        # ┗┛┻
        #
        "ui.background"           = { bg = "base00" }
        "ui.background.separator" = { bg = "base00" }

        "ui.cursor"                = { fg = "base05", bg = "highlight_high" }
        "ui.cursor.normal"         = { fg = "base05", bg = "highlight_high" }
        "ui.cursor.insert"         = { fg = "base05", bg = "highlight_med"  }
        "ui.cursor.select"         = { fg = "base05", bg = "highlight_high" }
        "ui.cursor.match"          = { fg = "base05", bg = "highlight_med"  }
        "ui.cursor.primary"        = { fg = "base05", bg = "highlight_high" }
        "ui.cursor.primary.normal" = { fg = "base05", bg = "highlight_high" }
        "ui.cursor.primary.insert" = { fg = "base05", bg = "highlight_med"  }
        "ui.cursor.primary.select" = { fg = "base05", bg = "highlight_high" }

        "ui.linenr"          = { fg = "base03" }
        "ui.linenr.selected" = { fg = "base05" }

        "ui.bufferline"          = { fg = "base03", bg = "base00" }
        "ui.bufferline.active"   = { fg = "base05", bg = "base02" }
        "ui.statusline"          = { fg = "base04", bg = "base01" }
        "ui.statusline.inactive" = { fg = "base03", bg = "base01" }
        "ui.statusline.normal"   = { fg = "base0A", bg = "base0A_15" }
        "ui.statusline.insert"   = { fg = "base0C", bg = "base0C_15" }
        "ui.statusline.select"   = { fg = "base0D", bg = "base0D_15" }

        "ui.popup"      = { bg = "base01" }
        "ui.popup.info" = { bg = "base01" }
        "ui.window"     = { fg = "base02", bg = "base00" }
        "ui.help"       = { fg = "base04", bg = "base02" }

        "ui.text"           = { fg = "base05" }
        "ui.text.focus"     = { bg = "base02" }
        "ui.text.info"      = { fg = "base04" }
        "ui.text.directory" = { fg = "base0D" }

        "ui.virtual.jump-label"   = { fg = "base08", modifiers = ["bold"] }
        "ui.virtual.ruler"        = { bg = "base02" }
        "ui.virtual.whitespace"   = { fg = "highlight_high" }
        "ui.virtual.indent-guide" = { fg = "base03" }
        "ui.virtual.inlay-hint"   = { fg = "base04" }

        "ui.menu"          = { fg = "base04", bg = "base01" }
        "ui.menu.selected" = { fg = "base05", bg = "base02" }
        "ui.menu.scroll"   = { fg = "base03", bg = "highlight_med" }

        "ui.selection"         = { bg = "base02" }
        "ui.selection.primary" = { bg = "highlight_med" }

        "ui.cursorline.primary"   = { bg = "highlight_low" }
        "ui.cursorline.secondary" = { bg = "base01" }

        # ┳┓┳┏┓┏┓┳┓┏┓┏┓┏┳┓┳┏┓┏┓
        # ┃┃┃┣┫┃┓┃┃┃┃┗┓ ┃ ┃┃ ┗┓
        # ┻┛┻┛┗┗┛┛┗┗┛┗┛ ┻ ┻┗┛┗┛
        #
        "warning" = "base09"
        "error"   = "base08"
        "info"    = "base0C"
        "hint"    = "base0D"
        "debug"   = "base0A"

        "diagnostic"             = { underline = { color = "base04", style = "curl" } }
        "diagnostic.hint"        = { underline = { color = "base0D", style = "curl" } }
        "diagnostic.info"        = { underline = { color = "base0C", style = "curl" } }
        "diagnostic.warning"     = { underline = { color = "base09", style = "curl" } }
        "diagnostic.error"       = { underline = { color = "base08", style = "curl" } }
        "diagnostic.unnecessary" = { modifiers = ["dim"] }
        "diagnostic.deprecated"  = { modifiers = ["crossed_out"] }

        # ┳┓┳┏┓┏┓
        # ┃┃┃┣ ┣
        # ┻┛┻┻ ┻
        #
        "diff"       = "base02"
        "diff.plus"  = "base0C"
        "diff.minus" = "base08"
        "diff.delta" = "highlight_high"

        # ┏┓┓┏┳┓┏┳┓┏┓┏┓┏┓
        # ┗┓┗┫┃┃ ┃ ┣┫ ┃┃
        # ┗┛┗┛┛┗ ┻ ┛┗┗┛┗┛
        #
        "special"   = "base0A"
        "attribute" = "base0D"

        "type"        = "base0C"
        "constructor" = "base0C"

        "constant"                  = "base0C"
        "constant.builtin"          = "base08"
        "constant.builtin.boolean"  = "base0A"
        "constant.character"        = "base09"
        "constant.character.escape" = "base0B"
        "constant.numeric"          = "base09"

        "string"                = "base09"
        "string.special.symbol" = "base0D"

        "comment" = { fg = "base03", modifiers = ["italic"] }

        "variable"              = "base05"
        "variable.builtin"      = "base08"
        "variable.parameter"    = "base0D"
        "variable.other.member" = "base0C"

        "label"       = "base0C"
        "punctuation" = "base04"

        "keyword"          = "base0B"
        "keyword.operator" = "base04"

        "operator" = "base04"

        "function"         = "base0A"
        "function.builtin" = { fg = "base08", modifiers = ["bold"] }

        "tag"       = "base0C"
        "namespace" = "base05"

        # ┳┳┓┏┓┳┓┓┏┓┳┳┏┓
        # ┃┃┃┣┫┣┫┃┫ ┃┃┃┃
        # ┛ ┗┛┗┛┗┛┗┛┗┛┣┛
        #
        "markup.heading.marker" = "base03"
        "markup.heading"   = { fg = "base0D", modifiers = ["bold"] }
        "markup.heading.1" = { fg = "base0D", modifiers = ["bold"] }
        "markup.heading.2" = { fg = "base0C", modifiers = ["bold"] }
        "markup.heading.3" = { fg = "base0A", modifiers = ["bold"] }
        "markup.heading.4" = { fg = "base09", modifiers = ["bold"] }
        "markup.heading.5" = { fg = "base0B", modifiers = ["bold"] }
        "markup.heading.6" = { fg = "base0C", modifiers = ["bold"] }
        "markup.list"          = "base03"
        "markup.bold"          = { modifiers = ["bold"] }
        "markup.italic"        = { modifiers = ["italic"] }
        "markup.strikethrough" = { modifiers = ["crossed_out"] }
        "markup.link"          = "base0D"
        "markup.link.url"      = { fg = "base0D", underline = { color = "base0D", style = "line" } }
        "markup.link.label"    = "base04"
        "markup.link.text"     = "base05"
        "markup.quote"         = "base04"
        "markup.raw"           = "base04"
        "markup.raw.inline"    = "base09"
        "markup.raw.block"     = "base09"

        # ┏┓┏┓┓ ┏┓┏┳┓┏┳┓┏┓
        # ┃┃┣┫┃ ┣  ┃  ┃ ┣
        # ┣┛┛┗┗┛┗┛ ┻  ┻ ┗┛
        #
        [palette]
        base00 = "${base00}"
        base01 = "${base01}"
        base02 = "${base02}"
        base03 = "${base03}"
        base04 = "${base04}"
        base05 = "${base05}"
        base06 = "${base06}"
        base07 = "${base07}"
        base08 = "${base08}"
        base09 = "${base09}"
        base0A = "${base0A}"
        base0B = "${base0B}"
        base0C = "${base0C}"
        base0D = "${base0D}"
        base0E = "${base0E}"
        base0F = "${base0F}"

        highlight_low  = "#${highlight_low}"
        highlight_med  = "#${highlight_med}"
        highlight_high = "#${highlight_high}"

        base08_15 = "#${base08_15}"
        base09_15 = "#${base09_15}"
        base0A_15 = "#${base0A_15}"
        base0B_15 = "#${base0B_15}"
        base0C_15 = "#${base0C_15}"
        base0D_15 = "#${base0D_15}"
      '');
  };
}

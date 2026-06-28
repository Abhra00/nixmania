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

    base08_20 = hsluv.mixRGB stx.base00 stx.base08 0.20;
    base09_20 = hsluv.mixRGB stx.base00 stx.base09 0.20;
    base0A_20 = hsluv.mixRGB stx.base00 stx.base0A 0.20;
    base0B_20 = hsluv.mixRGB stx.base00 stx.base0B 0.20;
    base0C_20 = hsluv.mixRGB stx.base00 stx.base0C 0.20;
    base0D_20 = hsluv.mixRGB stx.base00 stx.base0D 0.20;
    base0F_20 = hsluv.mixRGB stx.base00 stx.base0F 0.20;
  in {
    hm.programs.helix.settings.theme = lib.mkIf cfg "stylix";

    hm.xdg.configFile."helix/themes/stylix.toml".text =
      lib.mkIf cfg
      (with stx; ''
        # ┳┳┳
        # ┃┃┃
        # ┗┛┻
        #
        "ui.background"           = { fg = "base05", bg = "base00" }
        "ui.background.separator" = { fg = "base03" }

        "ui.cursor"                = { fg = "base00", bg = "base05" }
        "ui.cursor.normal"         = { fg = "base00", bg = "base05" }
        "ui.cursor.insert"         = { fg = "base00", bg = "base05" }
        "ui.cursor.select"         = { fg = "base00", bg = "base0F" }
        "ui.cursor.match"          = { fg = "base08", bg = "base08_20", modifers = ["bold"] }
        "ui.cursor.primary"        = { fg = "base00", bg = "base05" }
        "ui.cursor.primary.normal" = { fg = "base00", bg = "base05" }
        "ui.cursor.primary.insert" = { fg = "base00", bg = "base05" }
        "ui.cursor.primary.select" = { fg = "base00", bg = "base0F" }

        "ui.debug.breakpoint" = { fg = "base08" }
        "ui.debug.active"     = { fg = "base0A" }

        "ui.gutter"          = { bg = "base00" }
        "ui.gutter.selected" = { bg = "highlight_low" }
        "ui.linenr"          = { fg = "base03" }
        "ui.linenr.selected" = { fg = "base05" }

        "ui.bufferline"            = { fg = "base03", bg = "base00" }
        "ui.bufferline.active"     = { fg = "base05", bg = "base02" }
        "ui.bufferline.background" = { bg = "base00" }

        "ui.statusline"           = { fg = "base04", bg = "base01" }
        "ui.statusline.inactive"  = { fg = "base03", bg = "base01" }
        "ui.statusline.normal"    = { fg = "base0F", bg = "base0F_20" }
        "ui.statusline.insert"    = { fg = "base0B", bg = "base0B_20" }
        "ui.statusline.select"    = { fg = "base09", bg = "base09_20" }
        "ui.statusline.separator" = { fg = "base03" }

        "ui.popup"                       = { fg = "base05", bg = "base01" }
        "ui.popup.info"                  = { fg = "base04", bg = "base01" }
        "ui.picker.header"               = { fg = "base04", bg = "base01" }
        "ui.picker.header.column"        = { fg = "base04" }
        "ui.picker.header.column.active" = { fg = "base0D", modifiers = ["bold"] }
        "ui.window"                      = { fg = "base02", bg = "base00" }
        "ui.help"                        = { fg = "base04", bg = "base00" }

        "ui.text"           = { fg = "base05" }
        "ui.text.focus"     = { bg = "base02" }
        "ui.text.inactive"  = { fg = "base03" }
        "ui.text.info"      = { fg = "base04" }
        "ui.text.directory" = { fg = "base0D" }
        "ui.text.symlink"   = { fg = "base0C" }

        "ui.virtual.jump-label"             = { fg = "base08", modifiers = ["bold"] }
        "ui.virtual.ruler"                  = { bg = "base01" }
        "ui.virtual.whitespace"             = { fg = "highlight_high" }
        "ui.virtual.indent-guide"           = { fg = "base03" }
        "ui.virtual.inlay-hint"             = { fg = "base04" }
        "ui.virtual.inlay-hint.parameter"   = { fg = "base04" }
        "ui.virtual.inlay-hint.type"        = { fg = "base0C" }
        "ui.virtual.wrap"                   = { fg = "base03" }

        "ui.menu"          = { fg = "base04", bg = "base01" }
        "ui.menu.selected" = { fg = "base05", bg = "base02" }
        "ui.menu.scroll"   = { fg = "base03", bg = "highlight_med" }

        "ui.selection"         = { bg = "base02" }
        "ui.selection.primary" = { bg = "base02" }

        "ui.highlight"           = { bg = "highlight_low" }
        "ui.highlight.frameline" = { bg = "base0A_20" }

        "ui.cursorline.primary"     = { bg = "base01" }
        "ui.cursorline.secondary"   = { bg = "base02" }
        "ui.cursorcolumn.primary"   = { bg = "base01" }
        "ui.cursorcolumn.secondary" = { bg = "base02" }

        # ┳┓┳┏┓┏┓┳┓┏┓┏┓┏┳┓┳┏┓┏┓
        # ┃┃┃┣┫┃┓┃┃┃┃┗┓ ┃ ┃┃ ┗┓
        # ┻┛┻┛┗┗┛┛┗┗┛┗┛ ┻ ┻┗┛┗┛
        #
        "warning" = "base09"
        "error"   = "base08"
        "info"    = "base0C"
        "hint"    = "base0D"
        "debug"   = "base0A"

        "warning.diagnostic.inline" = "base09"
        "error.diagnostic.inline"   = "base08"
        "info.diagnostic.inline"    = "base0C"
        "hint.diagnostic.inline"    = "base0D"

        "diagnostic"             = { underline = { color = "base04", style = "curl" } }
        "diagnostic.hint"        = { underline = { color = "base0D", style = "curl" } }
        "diagnostic.info"        = { underline = { color = "base0C", style = "curl" } }
        "diagnostic.warning"     = { underline = { color = "base09", style = "curl" } }
        "diagnostic.error"       = { underline = { color = "base08", style = "curl" } }
        "diagnostic.unnecessary" = { modifiers = ["dim"] }
        "diagnostic.deprecated"  = { modifiers = ["crossed_out"] }

        "tabstop" = { bg = "highlight_med" }

        # ┳┓┳┏┓┏┓
        # ┃┃┃┣ ┣
        # ┻┛┻┻ ┻
        #
        "diff"                = "base02"
        "diff.plus"           = "base0B"
        "diff.plus.gutter"    = "base0B"
        "diff.minus"          = "base08"
        "diff.minus.gutter"   = "base08"
        "diff.delta"          = "base0A"
        "diff.delta.gutter"   = "base0A"
        "diff.delta.moved"    = "base0D"
        "diff.delta.conflict" = "base0E"

        # ┏┓┓┏┳┓┏┳┓┏┓┏┓┏┓
        # ┗┓┗┫┃┃ ┃ ┣┫ ┃┃
        # ┗┛┗┛┛┗ ┻ ┛┗┗┛┗┛
        #
        "special"   = "base0C"
        "attribute" = "base0C"

        "type"              = "base0C"
        "type.builtin"      = "base0C"
        "type.parameter"    = "base0A"
        "type.enum.variant" = "base09"
        "constructor"       = "base0E"

        "constant"                  = "base09"
        "constant.builtin"          = { fg = "base0C", modifiers = ["bold"] }
        "constant.builtin.boolean"  = "base09"
        "constant.character"        = "base0B"
        "constant.character.escape" = "base0E"
        "constant.numeric"          = "base09"
        "constant.numeric.integer"  = "base09"
        "constant.numeric.float"    = "base09"

        "string"                = "base0B"
        "string.regexp"         = "base07"
        "string.special.path"   = "base0B"
        "string.special.url"    = { fg = "base06", underline = { color = "base06", style = "line" } }
        "string.special.symbol" = "base0E"

        "comment"                       = { fg = "base03", modifiers = ["italic"] }
        "comment.line.documentation"    = { fg = "base0A", modifiers = ["italic"] }
        "comment.block.documentation"   = { fg = "base0A", modifiers = ["italic"] }
        "comment.unused"                = { fg = "base03", modifiers = ["italic", "dim"] }

        "variable"                      = "base05"
        "variable.builtin"              = "base08"
        "variable.parameter"            = "base0A"
        "variable.other.member"         = "base0C"
        "variable.other.member.private" = "base0C"

        "label"                 = "base0D"
        "punctuation"           = "base05"
        "punctuation.delimiter" = "base0C"
        "punctuation.bracket"   = "base05"
        "punctuation.special"   = "base0C"

        "keyword"                     = "base0F"
        "keyword.control"             = "base0E"
        "keyword.control.conditional" = "base0E"
        "keyword.control.repeat"      = "base0F"
        "keyword.control.import"      = "base0E"
        "keyword.control.return"      = "base0F"
        "keyword.control.exception"   = "base0E"
        "keyword.operator"            = "base0C"
        "keyword.directive"           = "base0C"
        "keyword.function"            = "base0E"
        "keyword.storage"             = "base0E"
        "keyword.storage.type"        = "base0E"
        "keyword.storage.modifier"    = "base0E"

        "operator" = "base0C"

        "function"                = "base0D"
        "function.builtin"        = "base0C"
        "function.method"         = "base0D"
        "function.method.private" = "base0D"
        "function.macro"          = "base0C"
        "function.special"        = "base0C"

        "tag"         = "base0D"
        "tag.builtin" = "base0D"

        "namespace"   = "base0C"

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
        "markup.list"           = "base03"
        "markup.list.unnumbered" = "base03"
        "markup.list.numbered"   = "base03"
        "markup.list.checked"    = "base0B"
        "markup.list.unchecked"  = "base04"
        "markup.bold"          = { modifiers = ["bold"] }
        "markup.italic"        = { modifiers = ["italic"] }
        "markup.strikethrough" = { modifiers = ["crossed_out"] }
        "markup.link"          = "base0D"
        "markup.link.url"      = { fg = "base0D", underline = { color = "base0D", style = "line" } }
        "markup.link.label"    = "base04"
        "markup.link.text"     = "base05"
        "markup.quote"         = "base04"
        "markup.raw"           = "base0B"
        "markup.raw.inline"    = "base0B"
        "markup.raw.block"     = "base0B"

        "markup.normal.completion" = "base05"
        "markup.normal.hover"      = "base05"
        "markup.heading.completion" = { fg = "base0D", modifiers = ["bold"] }
        "markup.heading.hover"      = { fg = "base0D", modifiers = ["bold"] }
        "markup.raw.inline.completion" = "base0B"
        "markup.raw.inline.hover"      = "base0B"

        # rainbow brackets — cycles through accent colors
        rainbow = ["base08", "base09", "base0A", "base0B", "base0C", "base0D", "base0E", "base0F"]

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

        base08_20 = "#${base08_20}"
        base09_20 = "#${base09_20}"
        base0A_20 = "#${base0A_20}"
        base0B_20 = "#${base0B_20}"
        base0C_20 = "#${base0C_20}"
        base0D_20 = "#${base0D_20}"
        base0F_20 = "#${base0F_20}"
      '');
  };
}

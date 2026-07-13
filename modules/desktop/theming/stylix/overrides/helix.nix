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

    highlight_low = l stx.base00 0.15;
    highlight_med = l stx.base02 0.10;
    highlight_high = l stx.base02 0.20;

    base08_20 = hsluv.mixRGB stx.base00 stx.base08 0.20;
    base09_20 = hsluv.mixRGB stx.base00 stx.base09 0.20;
    base0A_20 = hsluv.mixRGB stx.base00 stx.base0A 0.20;
    base0B_20 = hsluv.mixRGB stx.base00 stx.base0B 0.20;
    base0C_20 = hsluv.mixRGB stx.base00 stx.base0C 0.20;
    base0D_20 = hsluv.mixRGB stx.base00 stx.base0D 0.20;
    base0E_20 = hsluv.mixRGB stx.base00 stx.base0E 0.20;
  in {
    hm.programs.helix.settings.theme = lib.mkIf cfg "stylix";

    hm.xdg.configFile."helix/themes/stylix.toml".text =
      lib.mkIf cfg
      (with stx; ''
        # ┳┳┳
        # ┃┃┃
        # ┗┛┻
        #
        "ui.background"                   = { fg = "base05", bg = "base00" }
        "ui.background.separator"         = { fg = "base03" }

        "ui.cursor"                       = { fg = "base00", bg = "base05" }
        "ui.cursor.normal"                = { fg = "base00", bg = "base05" }
        "ui.cursor.insert"                = { fg = "base00", bg = "base05" }
        "ui.cursor.select"                = { fg = "base00", bg = "base0E" }
        "ui.cursor.match"                 = { fg = "base08", bg = "base08_20", modifiers = ["bold"] }
        "ui.cursor.primary"               = { fg = "base00", bg = "base05" }
        "ui.cursor.primary.normal"        = { fg = "base00", bg = "base05" }
        "ui.cursor.primary.insert"        = { fg = "base00", bg = "base05" }
        "ui.cursor.primary.select"        = { fg = "base00", bg = "base0E" }

        "ui.debug.breakpoint"             = { fg = "base08" }
        "ui.debug.active"                 = { fg = "base0A" }

        "ui.gutter"                       = { bg = "base00" }
        "ui.gutter.selected"              = { bg = "base01" }
        "ui.linenr"                       = { fg = "base03" }
        "ui.linenr.selected"              = { fg = "base05" }

        "ui.bufferline"                   = { fg = "base03", bg = "base00" }
        "ui.bufferline.active"            = { fg = "base0E", bg = "base0E_20", underline = { color = "base0E", style = "line" }, modifiers = ["italic"] }
        "ui.bufferline.background"        = { bg = "base00" }

        "ui.statusline"                   = { fg = "base04", bg = "base01" }
        "ui.statusline.inactive"          = { fg = "base03", bg = "base01" }
        "ui.statusline.normal"            = { fg = "base0C", bg = "base0C_20" }
        "ui.statusline.insert"            = { fg = "base0B", bg = "base0B_20" }
        "ui.statusline.select"            = { fg = "base0E", bg = "base0E_20" }
        "ui.statusline.separator"         = { fg = "base03" }

        "ui.popup"                        = { fg = "base05", bg = "base01" }
        "ui.popup.info"                   = { fg = "base04", bg = "base01" }
        "ui.picker.header"                = { fg = "base04", bg = "base01" }
        "ui.picker.header.column"         = { fg = "base04" }
        "ui.picker.header.column.active"  = { fg = "base0D", modifiers = ["bold"] }
        "ui.window"                       = { fg = "base02", bg = "base00" }
        "ui.help"                         = { fg = "base04", bg = "base00" }

        "ui.text"                         = { fg = "base05" }
        "ui.text.focus"                   = { bg = "base02" }
        "ui.text.inactive"                = { fg = "base03" }
        "ui.text.info"                    = { fg = "base04" }
        "ui.text.directory"               = { fg = "base0D" }
        "ui.text.symlink"                 = { fg = "base0C" }

        "ui.virtual.jump-label"           = { fg = "base08", modifiers = ["bold"] }
        "ui.virtual.ruler"                = { bg = "base01" }
        "ui.virtual.whitespace"           = { fg = "highlight_high" }
        "ui.virtual.indent-guide"         = { fg = "base03" }
        "ui.virtual.inlay-hint"           = { fg = "base04", modifiers = ["italic"] }
        "ui.virtual.inlay-hint.parameter" = { fg = "base04", modifiers = ["italic"] }
        "ui.virtual.inlay-hint.type"      = { fg = "base0A", modifiers = ["italic"] }
        "ui.virtual.wrap"                 = { fg = "base03" }

        "ui.menu"                         = { fg = "base04", bg = "base01" }
        "ui.menu.selected"                = { fg = "base05", bg = "base02" }
        "ui.menu.scroll"                  = { fg = "base03", bg = "highlight_med" }

        "ui.selection"                    = { bg = "highlight_low" }
        "ui.selection.primary"            = { bg = "highlight_low" }

        "ui.highlight"                    = { bg = "highlight_low" }
        "ui.highlight.frameline"          = { bg = "base0A_20" }

        "ui.cursorline.primary"           = { bg = "base01" }
        "ui.cursorline.secondary"         = { bg = "none" }
        "ui.cursorcolumn.primary"         = { bg = "base01" }
        "ui.cursorcolumn.secondary"       = { bg = "base01" }

        # ┳┓┳┏┓┏┓┳┓┏┓┏┓┏┳┓┳┏┓┏┓
        # ┃┃┃┣┫┃┓┃┃┃┃┗┓ ┃ ┃┃ ┗┓
        # ┻┛┻┛┗┗┛┛┗┗┛┗┛ ┻ ┻┗┛┗┛
        #
        "warning"                         = "base0A"
        "error"                           = "base08"
        "info"                            = "base0D"
        "hint"                            = "base0E"
        "debug"                           = "base09"

        "warning.diagnostic.inline"       = "base0A"
        "error.diagnostic.inline"         = "base08"
        "info.diagnostic.inline"          = "base0D"
        "hint.diagnostic.inline"          = "base0E"

        "diagnostic"                      = { underline = { color = "base04", style = "curl" } }
        "diagnostic.hint"                 = { underline = { color = "base0E", style = "curl" } }
        "diagnostic.info"                 = { underline = { color = "base0D", style = "curl" } }
        "diagnostic.warning"              = { underline = { color = "base0A", style = "curl" } }
        "diagnostic.error"                = { underline = { color = "base08", style = "curl" } }
        "diagnostic.unnecessary"          = { modifiers = ["dim"] }
        "diagnostic.deprecated"           = { modifiers = ["crossed_out"] }

        "tabstop"                         = { bg = "highlight_med" }

        # ┳┓┳┏┓┏┓
        # ┃┃┃┣ ┣
        # ┻┛┻┻ ┻
        #
        "diff"                            = "base02"
        "diff.plus"                       = "base0B"
        "diff.plus.gutter"                = "base0B"
        "diff.minus"                      = "base08"
        "diff.minus.gutter"               = "base08"
        "diff.delta"                      = "base0E"
        "diff.delta.gutter"               = "base0E"
        "diff.delta.moved"                = "base0C"
        "diff.delta.conflict"             = { fg = "base0E", modifiers = ["bold"] }

        # ┏┓┓┏┳┓┏┳┓┏┓┏┓┏┓
        # ┗┓┗┫┃┃ ┃ ┣┫ ┃┃
        # ┗┛┗┛┛┗ ┻ ┛┗┗┛┗┛
        #
        "special"                         = "base0A"
        "attribute"                       = "base0A"

        "type"                            = "base0A"
        "type.builtin"                    = "base0A"
        "type.parameter"                  = "base0A"
        "type.enum.variant"               = "base0A"
        "constructor"                     = { fg = "base0D", modifiers = ["bold"] }

        "constant"                        = "base09"
        "constant.builtin"                = "base09"
        "constant.builtin.boolean"        = "base09"
        "constant.character"              = "base09"
        "constant.character.escape"       = "base0C"
        "constant.numeric"                = "base09"
        "constant.numeric.integer"        = "base09"
        "constant.numeric.float"          = "base09"

        "string"                          = "base0B"
        "string.regexp"                   = "base0C"
        "string.special.path"             = "base0B"
        "string.special.url"              = { fg = "base09", underline = { color = "base09", style = "line" } }
        "string.special.symbol"           = "base0B"

        "comment"                         = { fg = "base03", modifiers = ["italic"] }
        "comment.line.documentation"      = { fg = "base03", modifiers = ["italic", "bold"] }
        "comment.block.documentation"     = { fg = "base03", modifiers = ["italic", "bold"] }
        "comment.unused"                  = { fg = "base03", modifiers = ["italic", "dim"] }

        "variable"                        = "base05"
        "variable.builtin"                = { fg = "base05", modifiers = ["italic"] }
        "variable.parameter"              = "base05"
        "variable.other.member"           = "base05"
        "variable.other.member.private"   = { fg = "base05", modifiers = ["italic"] }

        "label"                           = "base0A"

        "punctuation"                     = "base0F"
        "punctuation.delimiter"           = "base0F"
        "punctuation.bracket"             = "base05"
        "punctuation.special"             = "base0F"

        "keyword"                         = "base0E"
        "keyword.control"                 = "base0E"
        "keyword.control.conditional"     = "base0E"
        "keyword.control.repeat"          = "base0E"
        "keyword.control.import"          = "base0D"
        "keyword.control.return"          = "base0E"
        "keyword.control.exception"       = "base0E"
        "keyword.operator"                = "base0E"
        "keyword.directive"               = "base0E"
        "keyword.function"                = "base0E"
        "keyword.storage"                 = "base0E"
        "keyword.storage.type"            = "base0E"
        "keyword.storage.modifier"        = "base0E"

        "operator"                        = "base05"

        "function"                        = "base0D"
        "function.builtin"                = "base0D"
        "function.method"                 = "base0D"
        "function.method.private"         = "base0D"
        "function.macro"                  = "base08"
        "function.special"                = "base0D"

        "tag"                             = "base0A"
        "tag.builtin"                     = "base0A"

        "namespace"                       = "base08"

        # ┳┳┓┏┓┳┓┓┏┓┳┳┏┓
        # ┃┃┃┣┫┣┫┃┫ ┃┃┃┃
        # ┛ ┗┛┗┛┗┛┗┛┗┛┣┛
        #
        "markup.heading.marker"           = "base03"
        "markup.heading"                  = { fg = "base0D", modifiers = ["bold"] }
        "markup.heading.1"                = { fg = "base0D", modifiers = ["bold"] }
        "markup.heading.2"                = { fg = "base0D", modifiers = ["bold"] }
        "markup.heading.3"                = { fg = "base0D", modifiers = ["bold"] }
        "markup.heading.4"                = { fg = "base0D" }
        "markup.heading.5"                = { fg = "base0D" }
        "markup.heading.6"                = { fg = "base0D" }
        "markup.list"                     = "base08"
        "markup.list.unnumbered"          = "base08"
        "markup.list.numbered"            = "base08"
        "markup.list.checked"             = "base0B"
        "markup.list.unchecked"           = "base08"
        "markup.bold"                     = { fg = "base0A", modifiers = ["bold"] }
        "markup.italic"                   = { fg = "base0E", modifiers = ["italic"] }
        "markup.strikethrough"            = { fg = "base03", modifiers = ["crossed_out"] }
        "markup.link"                     = "base05"
        "markup.link.url"                 = { fg = "base09", underline = { color = "base09", style = "line" } }
        "markup.link.label"               = "base04"
        "markup.link.text"                = "base08"
        "markup.quote"                    = "base0C"
        "markup.raw"                      = "base0B"
        "markup.raw.inline"               = "base0B"
        "markup.raw.block"                = "base0B"

        "markup.normal.completion"        = "base05"
        "markup.normal.hover"             = "base05"
        "markup.heading.completion"       = { fg = "base0D", modifiers = ["bold"] }
        "markup.heading.hover"            = { fg = "base0D", modifiers = ["bold"] }
        "markup.raw.inline.completion"    = "base0B"
        "markup.raw.inline.hover"         = "base0B"

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
        base0E_20 = "#${base0E_20}"
      '');
  };
}

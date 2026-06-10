{
  flake.modules.nixos.editor_helix = {
    config,
    lib,
    ...
  }: let
    cfg = config.stylix.enable or false;
    stx = config.lib.stylix.colors.withHashtag;
  in {
    hm.programs.helix.settings.theme = lib.mkIf cfg "stylix";

    hm.xdg.configFile."helix/themes/stylix.toml".text =
      lib.mkIf cfg
      (with stx; ''
        # ┏━╸┏━╸┏┓╻┏━╸┏━┓┏━┓╻
        # ┃╺┓┣╸ ┃┗┫┣╸ ┣┳┛┣━┫┃
        # ┗━┛┗━╸╹ ╹┗━╸╹┗╸╹ ╹┗━╸
        "attribute"   = "base0D"
        "comment"     = { fg = "base03", modifiers = ["italic"] }
        "constructor" = "base0B"
        "function"    = "base0D"
        "function.macro" = "base08"
        "keyword"     = { fg = "base0E" }
        "keyword.control.conditional" = { fg = "base0E", modifiers = ["italic"] }
        "label"       = "base0C"
        "namespace"   = { fg = "base0A", modifiers = ["italic"] }
        "operator"    = "base0E"
        "special"     = "base0D"
        "tag"         = "base0D"

        "type"              = "base0A"
        "type.builtin"      = "base0E"
        "type.enum.variant" = "base0C"

        "constant"                  = "base09"
        "constant.character"        = "base0C"
        "constant.character.escape" = "base08"
        "constant.numeric"          = "base09"

        "string"                 = "base0B"
        "string.regexp"          = "base08"
        "string.special"         = "base0D"
        "string.special.symbol"  = "base08"

        "variable"              = "base05"
        "variable.builtin"      = "base08"
        "variable.parameter"    = { fg = "base08", modifiers = ["italic"] }
        "variable.other.member" = "base0D"

        "punctuation"         = "base05"
        "punctuation.special" = "base0C"

        # ┏┳┓┏━┓┏━┓╻┏ ╻ ╻┏━┓
        # ┃┃┃┣━┫┣┳┛┣┻┓┃ ┃┣━┛
        # ╹ ╹╹ ╹╹┗╸╹ ╹┗━┛╹
        "markup.bold"          = { fg = "base08", modifiers = ["bold"] }
        "markup.italic"        = { fg = "base08", modifiers = ["italic"] }
        "markup.strikethrough" = { modifiers = ["crossed_out"] }
        "markup.list"          = "base0C"
        "markup.list.checked"  = "base0B"
        "markup.list.unchecked" = "base03"
        "markup.quote"         = "base08"
        "markup.raw"           = "base0B"

        "markup.link.text"  = "base0E"
        "markup.link.label" = "base0C"
        "markup.link.url"   = { fg = "base0D", modifiers = ["italic", "underlined"] }

        "markup.heading.marker" = "base03"
        "markup.heading.1" = { fg = "base08", modifiers = ["bold"] }
        "markup.heading.2" = { fg = "base09", modifiers = ["bold"] }
        "markup.heading.3" = { fg = "base0B", modifiers = ["bold"] }
        "markup.heading.4" = { fg = "base0C", modifiers = ["bold"] }
        "markup.heading.5" = { fg = "base0D", modifiers = ["bold"] }
        "markup.heading.6" = { fg = "base0E", modifiers = ["bold"] }

        # ╺┳┓╻┏━┓┏━╸┏┓╻┏━┓┏━┓╺┳╸╻┏━╸
        #  ┃┃┃┣━┫┃╺┓┃┗┫┃ ┃┗━┓ ┃ ┃┃
        # ╺┻┛╹╹ ╹┗━┛╹ ╹┗━┛┗━┛ ╹ ╹┗━╸
        error   = "base08"
        warning = "base0A"
        info    = "base0D"
        hint    = "base03"

        rainbow = ["base08", "base09", "base0A", "base0B", "base0C", "base0D"]

        "diagnostic"             = { modifiers = ["underlined"] }
        "diagnostic.error"       = { underline = { color = "base08", style = "curl" } }
        "diagnostic.warning"     = { underline = { color = "base0A", style = "curl" } }
        "diagnostic.info"        = { underline = { color = "base0D", style = "curl" } }
        "diagnostic.hint"        = { underline = { color = "base03", style = "curl" } }
        "diagnostic.unnecessary" = { modifiers = ["dim"] }
        "diagnostic.deprecated"  = { modifiers = ["crossed_out"] }

        "diff.delta" = "base0A"
        "diff.minus" = "base08"
        "diff.plus"  = "base0B"

        # ╻ ╻┏━┓┏━╸┏━┓   ╻┏┓╻╺┳╸┏━╸┏━┓┏━╸┏━┓┏━╸┏━╸
        # ┃ ┃┗━┓┣╸ ┣┳┛   ┃┃┗┫ ┃ ┣╸ ┣┳┛┣╸ ┣━┫┃  ┣╸
        # ┗━┛┗━┛┗━╸╹┗╸   ╹╹ ╹ ╹ ┗━╸╹┗╸╹  ╹ ╹┗━╸┗━╸
        "ui.background" = { bg = "base00" }
        "ui.gutter"     = { bg = "base00" }
        "ui.window"     = { fg = "base02", bg = "base00" }
        "ui.popup"      = { fg = "base05", bg = "base02" }
        "ui.popup.info" = { fg = "base0F", bg = "base02" }
        "ui.help"       = { fg = "base0F" }

        "ui.bufferline"            = { fg = "base04", bg = "base01" }
        "ui.bufferline.active"     = { fg = "base0A", bg = "base00", modifiers = ["bold"] }
        "ui.bufferline.background" = { bg = "base00" }

        "ui.cursor"                  = { fg = "base05", modifiers = ["reversed"] }
        "ui.cursor.primary"          = { fg = "base05", modifiers = ["reversed"] }
        "ui.cursor.primary.normal"   = { fg = "base00", bg = "base05" }
        "ui.cursor.primary.insert"   = { fg = "base00", bg = "base05" }
        "ui.cursor.primary.select"   = { fg = "base00", bg = "base0A" }
        "ui.cursor.normal"           = { fg = "base00", bg = "base03" }
        "ui.cursor.insert"           = { fg = "base00", bg = "base03" }
        "ui.cursor.select"           = { fg = "base00", bg = "base03" }
        "ui.cursor.match"            = { fg = "base0A", bg = "base02", modifiers = ["bold"] }
        "ui.cursorline.primary"      = { fg = "base05", bg = "base01" }

        "ui.debug.breakpoint" = { fg = "base08" }
        "ui.debug.active"     = { fg = "base0B" }

        "ui.linenr"          = { fg = "base03", bg = "base00" }
        "ui.linenr.selected" = { fg = "base04", bg = "base00", modifiers = ["bold"] }

        "ui.highlight" = { bg = "base02", modifiers = ["bold"] }

        "ui.menu"          = { fg = "base05", bg = "base02" }
        "ui.menu.scroll"   = { fg = "base03", bg = "base02" }
        "ui.menu.selected" = { fg = "base01", bg = "base0E", modifiers = ["bold"] }
        "ui.picker.header" = { modifiers = ["bold", "underlined"] }

        "ui.selection"         = { bg = "base02" }
        "ui.selection.primary" = { bg = "base02" }

        "ui.statusline"          = { fg = "base04", bg = "base01" }
        "ui.statusline.inactive" = { fg = "base04", bg = "base01" }
        "ui.statusline.normal"   = { fg = "base00", bg = "base0A", modifiers = ["bold"] }
        "ui.statusline.insert"   = { fg = "base00", bg = "base0B", modifiers = ["bold"] }
        "ui.statusline.select"   = { fg = "base00", bg = "base09", modifiers = ["bold"] }

        "ui.text"           = "base05"
        "ui.text.directory" = "base0D"
        "ui.text.focus"     = { fg = "base05", modifiers = ["bold"] }
        "ui.text.inactive"  = "base04"
        "ui.text.info"      = "base05"

        "ui.virtual"               = "base03"
        "ui.virtual.indent-guide"  = "base02"
        "ui.virtual.inlay-hint"    = { fg = "base03", bg = "base01" }
        "ui.virtual.jump-label"    = { fg = "base0A", modifiers = ["bold"] }
        "ui.virtual.ruler"         = { bg = "base01" }
        "ui.virtual.whitespace"    = "base02"
        "ui.virtual.wrap"          = "base03"

        # ┏━┓┏━┓╻  ┏━╸╺┳╸╺┳╸┏━╸
        # ┣━┛┣━┫┃  ┣╸  ┃  ┃ ┣╸
        # ╹  ╹ ╹┗━╸┗━╸ ╹  ╹ ┗━╸
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
      '');
  };
}

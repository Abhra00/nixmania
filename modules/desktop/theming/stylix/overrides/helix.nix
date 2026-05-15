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
        "debug"       = "base03"
        "function"    = { fg = "base0D" }
        "keyword"     = { fg = "base0E" }
        "label"       = "base05"
        "namespace"   = "base05"
        "operator"    = "base0E"
        "special"     = "base0D"
        "string"      = "base0B"
        "tag"         = "base0D"
        "type"        = "base0B"

        "constant"                  = "base0E"
        "constant.character.escape" = "base0D"
        "constant.numeric"          = "base0A"

        "variable"              = "base05"
        "variable.parameter"    = "base05"
        "variable.other.member" = "base0D"

        "punctuation"         = "base05"
        "punctuation.special" = "base0C"

        # ┏┳┓┏━┓┏━┓╻┏ ╻ ╻┏━┓
        # ┃┃┃┣━┫┣┳┛┣┻┓┃ ┃┣━┛
        # ╹ ╹╹ ╹╹┗╸╹ ╹┗━┛╹
        "markup.bold"          = { modifiers = ["bold"] }
        "markup.italic"        = { modifiers = ["italic"] }
        "markup.strikethrough" = { modifiers = ["crossed_out"] }
        "markup.list"          = "base0C"
        "markup.quote"         = "base04"
        "markup.raw"           = "base0B"

        "markup.link.text" = "base0E"
        "markup.link.url"  = { fg = "base0D", modifiers = ["italic", "underlined"] }

        "markup.heading.marker" = "base03"
        "markup.heading.1"      = { fg = "base08", modifiers = ["bold"] }
        "markup.heading.2"      = { fg = "base09", modifiers = ["bold"] }
        "markup.heading.3"      = { fg = "base0B", modifiers = ["bold"] }
        "markup.heading.4"      = { fg = "base0C", modifiers = ["bold"] }
        "markup.heading.5"      = { fg = "base0D", modifiers = ["bold"] }
        "markup.heading.6"      = { fg = "base0E", modifiers = ["bold"] }

        # ╺┳┓╻┏━┓┏━╸┏┓╻┏━┓┏━┓╺┳╸╻┏━╸
        #  ┃┃┃┣━┫┃╺┓┃┗┫┃ ┃┗━┓ ┃ ┃┃
        # ╺┻┛╹╹ ╹┗━┛╹ ╹┗━┛┗━┛ ╹ ╹┗━╸
        "error"   = { fg = "base08", modifiers = ["bold"] }
        "warning" = { fg = "base0A", modifiers = ["bold"] }
        "info"    = "base0D"
        "hint"    = "base03"

        "diagnostic"         = { modifiers = ["underlined"] }
        "diagnostic.error"   = { underline = { style = "curl" } }
        "diagnostic.warning" = { underline = { style = "curl" } }
        "diagnostic.info"    = { underline = { style = "curl" } }
        "diagnostic.hint"    = { underline = { style = "curl" } }

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
        "ui.help"       = { fg = "base0F"  }

        "ui.bufferline"        = { fg = "base04", bg = "base00" }
        "ui.bufferline.active" = { fg = "base00", bg = "base0E", modifiers = ["bold"] }

        "ui.cursor"             = { fg = "base05", modifiers = ["reversed"] }
        "ui.cursor.primary"     = { fg = "base05", modifiers = ["reversed"] }
        "ui.cursor.select"      = { fg = "base05", modifiers = ["reversed"] }
        "ui.cursor.match"       = { fg = "base05", bg = "base02", modifiers = ["bold"] }
        "ui.cursorline.primary" = { fg = "base05", bg = "base01" }

        "ui.debug.breakpoint" = { fg = "base08" }
        "ui.debug.active"     = { fg = "base0B" }

        "ui.linenr"          = { fg = "base03", bg = "base00" }
        "ui.linenr.selected" = { fg = "base04", bg = "base00", modifiers = ["bold"] }

        "ui.menu"          = { fg = "base05", bg = "base02" }
        "ui.menu.scroll"   = { fg = "base03", bg = "base02" }
        "ui.menu.selected" = { fg = "base01", bg = "base0E", modifiers = ["bold"] }
        "ui.picker.header" = { modifiers = ["bold", "underlined"] }

        "ui.selection"         = { bg = "base02" }
        "ui.selection.primary" = { bg = "base02" }

        "ui.statusline"           = { fg = "base05", bg = "base01" }
        "ui.statusline.inactive"  = { fg = "base04", bg = "base01" }
        "ui.statusline.normal"    = { fg = "base00", bg = "base0E", modifiers = ["bold"] }
        "ui.statusline.insert"    = { fg = "base00", bg = "base0B", modifiers = ["bold"] }
        "ui.statusline.select"    = { fg = "base00", bg = "base0F", modifiers = ["bold"] }

        "ui.text"           = "base05"
        "ui.text.directory" = "base0D"
        "ui.text.focus"     = { fg = "base05", modifiers = ["bold"] }
        "ui.text.inactive"  = "base04"
        "ui.text.info"      = "base05"

        "ui.virtual.indent-guide" = "base03"
        "ui.virtual.inlay-hint"   = "base03"
        "ui.virtual.jump-label"   = { fg = "base0A", modifiers = ["bold"] }
        "ui.virtual.ruler"        = { bg = "base01" }
        "ui.virtual.whitespace"   = "base03"

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

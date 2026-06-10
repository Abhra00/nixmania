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
        "attribute" = "base0D"
        "type"      = "base0C"
        "constructor" = "base0C"
        "constant"  = "base0C"
        "constant.builtin" = "base08"
        "constant.builtin.boolean" = "base0A"
        "constant.character" = "base09"
        "constant.character.escape" = "base0B"
        "constant.numeric" = "base09"

        "string" = "base09"
        "string.special.symbol" = "base0D"

        "comment" = { fg = "base03", modifiers = ["italic"] }

        "variable" = "base05"
        "variable.builtin" = "base08"
        "variable.parameter" = "base0D"
        "variable.other.member" = "base0C"

        "label"        = "base0C"
        "punctuation"  = "base04"
        "keyword"      = "base0B"
        "keyword.operator" = "base04"
        "operator"     = "base04"

        "function"     = "base0A"
        "function.builtin" = { fg = "base0A", modifiers = ["bold"] }

        "tag"       = "base0C"
        "namespace" = "base05"
        "special"   = "base0A"

        # ┏┳┓┏━┓┏━┓╻┏ ╻ ╻┏━┓
        # ┃┃┃┣━┫┣┳┛┣┻┓┃ ┃┣━┛
        # ╹ ╹╹ ╹╹┗╸╹ ╹┗━┛╹
        "markup.heading.marker" = "base03"
        "markup.heading"   = { fg = "base0D", modifiers = ["bold"] }
        "markup.heading.1" = { fg = "base0D", modifiers = ["bold"] }
        "markup.heading.2" = { fg = "base0C", modifiers = ["bold"] }
        "markup.heading.3" = { fg = "base0A", modifiers = ["bold"] }
        "markup.heading.4" = { fg = "base09", modifiers = ["bold"] }
        "markup.heading.5" = { fg = "base0B", modifiers = ["bold"] }
        "markup.heading.6" = { fg = "base0C", modifiers = ["bold"] }
        "markup.list"      = "base03"
        "markup.bold"      = { modifiers = ["bold"] }
        "markup.italic"    = { modifiers = ["italic"] }
        "markup.strikethrough" = { modifiers = ["crossed_out"] }
        "markup.link"      = "base0D"
        "markup.link.url"  = { fg = "base0D", underline = { color = "base0D", style = "line" } }
        "markup.link.label" = "base04"
        "markup.link.text"  = "base0C"
        "markup.quote"     = "base04"
        "markup.raw"       = "base04"
        "markup.raw.inline" = "base09"
        "markup.raw.block"  = "base09"

        # ╺┳┓╻┏━┓┏━╸┏┓╻┏━┓┏━┓╺┳╸╻┏━╸
        #  ┃┃┃┣━┫┃╺┓┃┗┫┃ ┃┗━┓ ┃ ┃┃
        # ╺┻┛╹╹ ╹┗━┛╹ ╹┗━┛┗━┛ ╹ ╹┗━╸
        "warning" = "base09"
        "error"   = "base08"
        "info"    = "base0C"
        "hint"    = "base0D"
        "debug"   = "base0A"

        "diagnostic"         = { underline = { color = "base04", style = "curl" } }
        "diagnostic.hint"    = { underline = { color = "base0D", style = "curl" } }
        "diagnostic.info"    = { underline = { color = "base0C", style = "curl" } }
        "diagnostic.warning" = { underline = { color = "base09", style = "curl" } }
        "diagnostic.error"   = { underline = { color = "base08", style = "curl" } }

        "diff"       = "base01"
        "diff.plus"  = "base0C"
        "diff.minus" = "base08"
        "diff.delta" = "base03"

        # ╻ ╻┏━┓┏━╸┏━┓  ╻┏┓╻╺┳╸┏━╸┏━┓┏━╸┏━┓┏━╸┏━╸
        # ┃ ┃┗━┓┣╸ ┣┳┛  ┃┃┗┫ ┃ ┣╸ ┣┳┛┣╸ ┣━┫┃  ┣╸
        # ┗━┛┗━┛┗━╸╹┗╸  ╹╹ ╹ ╹ ┗━╸╹┗╸╹  ╹ ╹┗━╸┗━╸
        "ui.background"           = { fg = "base05", bg = "base00" }
        "ui.background.separator" = { bg = "base00" }

        "ui.cursor"         = { fg = "base05", bg = "base03" }
        "ui.cursor.match"   = { fg = "base05", bg = "base02" }
        "ui.cursor.primary" = { fg = "base05", bg = "base03" }

        "ui.linenr"          = { fg = "base03" }
        "ui.linenr.selected" = { fg = "base05" }

        "ui.bufferline"        = { fg = "base03", bg = "base00" }
        "ui.bufferline.active" = { fg = "base05", bg = "base01" }
        "ui.statusline"        = { fg = "base04", bg = "base01" }
        "ui.statusline.inactive" = { fg = "base03", bg = "base01" }

        "ui.statusline.normal" = { fg = "base0A", bg = "base01" }
        "ui.statusline.insert" = { fg = "base0C", bg = "base01" }
        "ui.statusline.select" = { fg = "base0D", bg = "base01" }

        "ui.popup"         = { fg = "base05", bg = "base01" }
        "ui.picker.header" = { fg = "base0D", modifiers = ["bold"] }
        "ui.window"        = { fg = "base01", bg = "base00" }
        "ui.help"          = { fg = "base04", bg = "base00" }

        "ui.text"       = { fg = "base05" }
        "ui.text.focus" = { bg = "base01" }
        "ui.text.info"  = { fg = "base04" }

        "ui.virtual.jump-label"  = { fg = "base08", modifiers = ["bold"] }
        "ui.virtual.ruler"       = { bg = "base01" }
        "ui.virtual.whitespace"  = { fg = "base03" }
        "ui.virtual.indent-guide" = { fg = "base03" }
        "ui.virtual.inlay-hint"  = { fg = "base04" }

        "ui.menu"          = { fg = "base04", bg = "base01" }
        "ui.menu.selected" = { fg = "base05" }
        "ui.menu.scroll"   = { fg = "base03", bg = "base02" }

        "ui.selection"         = { bg = "base01" }
        "ui.selection.primary" = { bg = "base02" }

        "ui.cursorline.primary"   = { bg = "base01" }
        "ui.cursorline.secondary" = { bg = "base01" }

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

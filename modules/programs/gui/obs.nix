{
  flake.modules.nixos.gui_obs = {
    config,
    lib,
    pkgs,
    ...
  }: let
    c = config.lib.stylix.colors;
  in {
    hm.home.packages = [pkgs.obs-studio];

    hm.xdg.configFile."obs-studio/themes/stylix_obs.ovt".text = ''
      @OBSThemeMeta {
          name: 'Stylix';
          id: 'com.obsproject.Stylix';
          extends: 'com.obsproject.Yami';
          author: 'nixmania';
          dark: 'true';
      }

      @OBSThemeVars {
          --bg_window:  #${c.base00};
          --bg_base:    #${c.base01};
          --bg_preview: #${c.base00};

          --primary:         #${c.base0D};
          --primary_light:   #${c.base07};
          --primary_lighter: #${c.base07};
          --primary_dark:    #${c.base0D};
          --primary_darker:  #${c.base0D};

          --warning: #${c.base09};
          --danger:  #${c.base08};

          --text:          #${c.base05};
          --text_light:    #${c.base06};
          --text_muted:    #${c.base04};
          --text_disabled: #${c.base03};
          --text_inactive: #${c.base04};

          --scrollbar_bg:     #${c.base00};
          --scrollbar_handle: #${c.base02};
          --scrollbar_hover:  #${c.base03};
          --scrollbar_down:   #${c.base04};
          --scrollbar_border: #${c.base03};

          --border_color: #${c.base02};

          --input_bg:       #${c.base02};
          --input_bg_hover: #${c.base01};
          --input_bg_focus: #${c.base01};

          --input_border:       #${c.base02};
          --input_border_hover: #${c.base04};
          --input_border_focus: #${c.base0D};

          --list_item_bg_hover: #${c.base02};

          --button_bg:          #${c.base02};
          --button_bg_hover:    #${c.base03};
          --button_bg_down:     #${c.base00};
          --button_bg_disabled: #${c.base01};

          --button_border:       #${c.base02};
          --button_border_hover: #${c.base03};
          --button_border_focus: #${c.base03};

          --tab_bg:          #${c.base00};
          --tab_bg_hover:    #${c.base03};
          --tab_bg_down:     #${c.base02};
          --tab_bg_disabled: #${c.base00};

          --tab_border:          #${c.base03};
          --tab_border_hover:    #${c.base03};
          --tab_border_focus:    #${c.base07};
          --tab_border_selected: #${c.base0D};

          --separator_hover: #${c.base06};

          --highlight_color: #${c.base07};

          --palette_window:          #${c.base00};
          --palette_windowText:      #${c.base04};
          --palette_base:            #${c.base00};
          --palette_alternateBase:   #${c.base01};
          --palette_text:            #${c.base05};
          --palette_brightText:      #${c.base04};
          --palette_button:          #${c.base02};
          --palette_buttonText:      #${c.base04};
          --palette_light:           #${c.base02};
          --palette_mid:             #${c.base01};
          --palette_dark:            #${c.base00};
          --palette_shadow:          #${c.base00};
          --palette_highlight:       #${c.base03};
          --palette_highlightedText: #${c.base05};
          --palette_link:            #${c.base0D};
          --palette_linkVisited:     #${c.base0E};
          --palette_text_active:     #${c.base05};
          --palette_text_disabled:   #${c.base03};
          --palette_text_inactive:   #${c.base04};
      }

      QWidget {
          selection-background-color: #${c.base02};
      }

      #streamButton:!hover:!pressed.state-active,
      #recordButton:!hover:!pressed.state-active,
      #pauseRecordButton:!hover:!pressed.state-active,
      #replayBufferButton:!hover:!pressed.state-active,
      #virtualCamButton:!hover:!pressed.state-active,
      #modeSwitch:!hover:!pressed.state-active,
      #broadcastButton:!hover:!pressed.state-active {
          background: #${c.base0D};
          color: #${c.base00};
      }

      #streamButton:hover:!pressed.state-active,
      #recordButton:hover:!pressed.state-active,
      #pauseRecordButton:hover:!pressed.state-active,
      #replayBufferButton:!pressed.state-active,
      #virtualCamButton:!pressed.state-active,
      #modeSwitch:hover:!pressed.state-active,
      #broadcastButton:hover:!pressed.state-active {
          background: #${c.base07};
          color: #${c.base00};
      }

      QPushButton:checked,
      QPushButton:checked:hover,
      QPushButton:checked:focus {
          color: #${c.base00};
      }

      QMenu::item:selected,
      QMenu > QWidget:selected,
      QListView::item:selected,
      QListWidget::item:selected,
      SourceTree::item:selected,
      SourceTreeItem:selected {
          background-color: #${c.base03};
          color: #${c.base05};
          border-color: #${c.base04};
      }

      QMenu::item:selected:hover,
      QListView::item:selected:hover,
      QListWidget::item:selected:hover,
      SourceTree::item:selected:hover,
      SourceTreeItem:selected:hover {
          background-color: #${c.base04};
          color: #${c.base05};
      }

      QMenuBar::item:selected {
          background: #${c.base03};
          color: #${c.base05};
      }

      VolumeMeter {
          qproperty-backgroundNominalColor: #${c.base0B};
          qproperty-backgroundWarningColor: #${c.base09};
          qproperty-backgroundErrorColor:   #${c.base08};

          qproperty-foregroundNominalColor: #${c.base0B};
          qproperty-foregroundWarningColor: #${c.base09};
          qproperty-foregroundErrorColor:   #${c.base08};

          qproperty-backgroundNominalColorDisabled: #${c.base02};
          qproperty-backgroundWarningColorDisabled: #${c.base03};
          qproperty-backgroundErrorColorDisabled:   #${c.base04};
          qproperty-foregroundNominalColorDisabled: #${c.base03};
          qproperty-foregroundWarningColorDisabled: #${c.base03};
          qproperty-foregroundErrorColorDisabled:   #${c.base04};

          qproperty-magnitudeColor: #${c.base02};
          qproperty-majorTickColor: #${c.base05};
          qproperty-minorTickColor: #${c.base03};
          qproperty-peakDecayRate:  23.4;
      }

      VolumeControl .mixer-category {
          background: #${c.base03};
          color: #${c.base0E};
      }

      VolumeControl.volume-pinned .mixer-category {
          background: #${c.base04};
          color: #${c.base05};
      }

      VolumeControl.volume-hidden .mixer-category {
          background: #${c.base02};
          color: #${c.base0E};
      }

      VolumeControl.volume-unassigned .mixer-category {
          background: #${c.base02};
          color: #${c.base0A};
      }

      VolumeControl.volume-inactive .mixer-category {
          background: #${c.base02};
          color: #${c.base03};
      }

      VolumeControl.volume-preview .mixer-category {
          background: #${c.base02};
          color: #${c.base0B};
      }

      QSlider::sub-page:horizontal,
      QSlider::add-page:vertical {
          background-color: #${c.base0D};
      }

      .slider-tbar::sub-page:horizontal {
          background: #${c.base0D};
      }

      #previewXContainer,
      #previewScalingMode {
          border: 1px solid #${c.base01};
      }

      #previewScalingMode:hover,
      #previewScalingMode:focus {
          border-color: #${c.base01};
      }

      #previewXScrollBar,
      #previewYScrollBar {
          border: 1px solid #${c.base01};
      }
    '';
  };
}

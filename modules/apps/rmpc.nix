{
  nawa.apps._.rmpc = {
    homeManager =
      { config, pkgs, ... }:
      let
        inherit (config.lib.file) mkOutOfStoreSymlink;
        inherit (config.home) homeDirectory;
        inherit (config.lib.stylix) colors;

        rmpcConfigDir = "${homeDirectory}/majarra/config/rmpc";
        rmpcTheme = with colors.withHashtag; ''
          #![enable(implicit_some)]
          #![enable(unwrap_newtypes)]
          #![enable(unwrap_variant_newtypes)]
          (
                default_album_art_path: None,
                show_song_table_header: true,
                draw_borders: true,
                browser_column_widths: [20, 38, 42],
                background_color: "${base00}",
                text_color: "${base05}",
                header_background_color: None,
                modal_background_color: None,
                tab_bar: (
                      enabled: true,
                      active_style: (fg: "${base01}", bg: "${base0D}", modifiers: "Bold"),  
                      inactive_style: (),
                ),
                highlighted_item_style: (fg: "${base08}", modifiers: "Bold"),             
                current_item_style: (fg: "${base0E}", bg: "${base00}", modifiers: "Bold"),  
                borders_style: (fg: "${base0D}"),                                         
                highlight_border_style: (fg: "${base08}", bg: "${base01}", modifiers: "Bold"),                                
                symbols: (song: "S", dir: "D", marker: "M", ellipsis: "..."),
                progress_bar: (
                      symbols: ["█", "", " "],
                      track_style: (fg: "${base02}"),                                     
                      elapsed_style: (fg: "${base0A}"),                                   
                      thumb_style: (fg: "${base0A}"),                                     
                ),
                scrollbar: (
                      symbols: ["│", "█", "▲", "▼"],
                      track_style: (),
                      ends_style: (),
                      thumb_style: (fg: "${base0B}"),                                     
                ),
                song_table_format: [
                (
                            prop: (kind: Property(Artist),
                                  default: (kind: Text("Unknown"))
                            ),
                            width: "20%",
                      ),
                (
                            prop: (kind: Property(Title),
                                  default: (kind: Text("Unknown"))
                            ),
                            width: "35%",
                      ),
                (
                            prop: (kind: Property(Album), style: (fg: "${base05}"),
                                  default: (kind: Text("Unknown Album"), style: (fg: "${base05}"))
                            ),
                            width: "30%",
                      ),
                (
                            prop: (kind: Property(Duration),
                                  default: (kind: Text("-"))
                            ),
                            width: "15%",
                            alignment: Right,
                      ),
                ],
                layout: Split(
                      direction: Vertical,
                      panes: [
                      (
                                  pane: Pane(Header),
                                  borders: "ALL",
                                  size: "4",
                            ),
                      (
                                  pane: Pane(Tabs),
                                  size: "3",
                            ),
                      (
                                  pane: Pane(TabContent),
                                  borders: "ALL",
                                  size: "100%",
                            ),
                      (
                                  pane: Pane(ProgressBar),
                                  borders: "ALL",
                                  size: "3",
                            ),
                      ],
                ),
                header: (
                      rows: [
                      (
                                  left: [
                                  (kind: Text("["), style: (fg: "${base08}", modifiers: "Bold")),
                                  (kind: Property(Status(StateV2(playing_label: "Playing", paused_label: "Paused", stopped_label: "Stopped"))), style: (fg: "${base08}", modifiers: "Bold")),
                                  (kind: Text("]"), style: (fg: "${base08}", modifiers: "Bold"))
                                  ],
                                  center: [
                                  (kind: Property(Song(Title)), style: (fg: "${base0E}", modifiers: "Bold"),
                                              default: (kind: Text("No Song"), style: (fg: "${base0E}", modifiers: "Bold"))
                                        )
                                  ],
                                  right: [
                                  (kind: Property(Widget(Volume)), style: (fg: "${base0D}"))
                                  ]
                            ),
                      (
                                  left: [
                                  (kind: Property(Status(Elapsed))),
                                  (kind: Text(" / ")),
                                  (kind: Property(Status(Duration))),
                                  (kind: Text(" (")),
                                  (kind: Property(Status(Bitrate))),
                                  (kind: Text(" kbps)"))
                                  ],
                                  center: [
                                  (kind: Property(Song(Artist)), style: (fg: "${base0A}", modifiers: "Bold"),
                                              default: (kind: Text("Unknown"), style: (fg: "${base0A}", modifiers: "Bold"))
                                        ),
                                  (kind: Text(" - ")),
                                  (kind: Property(Song(Album)), style: (fg: "${base0D}", modifiers: "Bold"),
                                              default: (kind: Text("Unknown Album"), style: (fg: "${base0B}", modifiers: "Bold"))
                                        )
                                  ],
                                  right: [
                                  (
                                              kind: Property(Widget(States(
                                                    active_style: (fg: "${base05}", modifiers: "Bold"),
                                                    separator_style: (fg: "${base05}")))
                                              ),
                                              style: (fg: "${base03}")
                                        ),
                                  ]
                            ),
                      ],
                ),
                browser_song_format: [
                (
                            kind: Group([
                            (kind: Property(Track)),
                            (kind: Text(" ")),
                            ])
                      ),
                (
                            kind: Group([
                            (kind: Property(Artist)),
                            (kind: Text(" - ")),
                            (kind: Property(Title)),
                            ]),
                            default: (kind: Property(Filename))
                      ),
                ],
          )
        '';
        notify_track_change = pkgs.writeScriptBin "notify_track_change" ''
          #!/usr/bin/env sh

          # Directory where to store temporary data
          TMP_DIR="/tmp/rmpc"

          # Ensure the directory is created
          mkdir -p "$TMP_DIR"

          # Where to temporarily store the album art received from rmpc
          ALBUM_ART_PATH="$TMP_DIR/notification_cover"

          # Path to fallback album art if no album art is found by rmpc/mpd
          # Change this to your needs
          DEFAULT_ALBUM_ART_PATH="$TMP_DIR/default_album_art.jpg"

          # Save album art of the currently playing song to a file
          if ! rmpc albumart --output "$ALBUM_ART_PATH"; then
              # Use default album art if rmpc returns non-zero exit code
              ALBUM_ART_PATH="$DEFAULT_ALBUM_ART_PATH"
          fi

          # Send the notification
          notify-send -i "$ALBUM_ART_PATH" -a "rmpc" "Now Playing" "$ARTIST - $TITLE"
        '';
      in
      {
        home.packages = [
          pkgs.rmpc
          notify_track_change
        ];
        xdg.configFile = {
          "rmpc/config.ron".source = mkOutOfStoreSymlink "${rmpcConfigDir}/config.ron";
          "rmpc/themes/stylix.ron".text = rmpcTheme;
        };
        services.mpdris2-rs.enable = true;
        services.mpd = {
          enable = true;
          network.listenAddress = "/tmp/mpd_socket";
          extraConfig = ''
            audio_output {
                    type            "pipewire"
                    name            "PipeWire Sound Server"
            }
          '';
        };
      };
  };
}

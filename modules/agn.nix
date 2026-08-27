{
  den,
  __findFile,
  ...
}:
{
  den.aspects.agn = {
    includes = [
      <den/primary-user>
      (<den/tty-autologin> "agn")

      <nawa/core>
      <nawa/secrets>

      <nawa/apps/zen>
      <nawa/apps/wezterm>
      <nawa/apps/cli/full>
      <nawa/apps/niri>
      <nawa/apps/umbriel>
      <nawa/apps/neovim>
      <nawa/apps/zk>
      <nawa/apps/starship>
      <nawa/apps/yazi>
      <nawa/apps/zellij>

      <nawa/services/syncthing/client>
    ];
  };
}

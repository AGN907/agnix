{
  config,
  pkgs,
  ...
}:
{

  config.info = {
    colorscheme = "vague";
    nixd = rec {
      flake = "builtins.getFlake (toString /home/agn/majarra)";
      nixpkgs = "import (${flake}).inputs.nixpkgs { }";
      nixos = "(${flake}).nixosConfigurations.alkaid.options";
      homeManager = "(${flake}).nixosConfigurations.alkaid.options.home-manager.users.type.getSubOptions []";
    };
    svelteTypescriptPlugin = "${pkgs.svelte-language-server}/node_modules/typescript-svelte-plugin";
  };

  config.specs.general = {
    data = with pkgs.vimPlugins; [
      config.nvim-lib.neovimPlugins.lze
      mini-basics
      mini-comment
      mini-extra
      mini-notify
      mini-icons
      mini-input
      mini-misc
      snacks-nvim
      which-key-nvim
      quicker-nvim
      vague-nvim
      {
        data = config.nvim-lib.neovimPlugins.lzextras;
        name = "lzextras";
      }
    ];
  };

  config.specs.lsp = {
    lazy = true;
    data = pkgs.vimPlugins.nvim-lspconfig;
  };

  config.specs.cmp = {
    lazy = true;
    data = with pkgs.vimPlugins; [
      blink-cmp
      colorful-menu-nvim
      mini-snippets
      friendly-snippets
    ];
  };

  config.specs.lint = {
    lazy = true;
    data = with pkgs.vimPlugins; [
      nvim-lint
    ];
  };

  config.specs.format = {
    lazy = true;
    data = pkgs.vimPlugins.conform-nvim;
  };

  config.specs.treesitter = {
    data = with pkgs.vimPlugins; [
      nvim-treesitter-textobjects
      (nvim-treesitter.withPlugins (
        p: with p; [
          lua
          nix
          markdown
          markdown_inline
          comment
          json
          yaml
          toml
          typescript
          svelte
          go
          gomod
          gosum
          gotmpl
          gitcommit
          gitignore
          kdl
          just
          php
          php_only
          blade
          sql
          html
          diff
          proto
          dart
          sql
        ]
      ))
    ];
    runtimePkgs = [ pkgs.tree-sitter ];
  };

  config.specs.editor = {
    lazy = true;
    data = with pkgs.vimPlugins; [
      mini-bufremove
      mini-files
      mini-sessions
      mini-tabline
      fzf-lua
      tiny-inline-diagnostic-nvim
      config.nvim-lib.neovimPlugins.tiny-code-action
      config.nvim-lib.neovimPlugins.mini-statuscolumn
    ];
  };

  config.specs.coding = {
    lazy = true;
    data = with pkgs.vimPlugins; [
      mini-ai
      mini-align
      mini-bracketed
      mini-jump
      mini-operators
      mini-splitjoin
      mini-surround
      mini-move
      SchemaStore-nvim
    ];
  };

  config.specs.ui = {
    lazy = true;
    data = with pkgs.vimPlugins; [
      mini-animate
      mini-hipatterns
      mini-indentscope
    ];
  };

  config.specs.git = {
    lazy = true;
    data = with pkgs.vimPlugins; [
      mini-git
      mini-diff
    ];
    runtimePkgs = [
      pkgs.lazygit
    ];
  };

  # Languages Support
  config.specs.nix = {
    data = null;
    runtimePkgs = with pkgs; [
      nixd
      nixfmt
    ];
  };
  config.specs.lua = {
    lazy = true;
    data = with pkgs.vimPlugins; [
      lazydev-nvim
    ];
    runtimePkgs = with pkgs; [
      lua-language-server
      stylua
    ];
  };
  config.specs.typescript = {
    lazy = false;
    data = null;
    runtimePkgs = with pkgs; [
      vtsls
      biome
      svelte-language-server
    ];
  };

  config.specs.markdown = {
    lazy = false;
    data = with pkgs.vimPlugins; [
      render-markdown-nvim
      zk-nvim
    ];
  };

  config.specs.yaml = {
    lazy = false;
    data = null;
    runtimePkgs = [
      pkgs.yaml-language-server
    ];
  };

  config.specs.json = {
    lazy = false;
    data = null;
    runtimePkgs = with pkgs; [
      vscode-json-languageserver
    ];
  };

  config.specs.toml = {
    lazy = false;
    data = null;
    runtimePkgs = [
      pkgs.tombi
    ];
  };

  config.specs.go = {
    lazy = false;
    data = null;
    runtimePkgs = with pkgs; [
      gopls
      golangci-lint
      gofumpt
      gotestsum
    ];
  };

  config.specs.testing = {
    lazy = false;
    data = with pkgs.vimPlugins; [
      neotest
      plenary-nvim
      nvim-nio
      neotest-golang
    ];
  };

  config.specs.utils = {
    data = [
      {
        name = "zellij-vim";
        data = config.nvim-lib.neovimPlugins.zellij-vim;
      }
    ];
  };

}

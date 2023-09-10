/*
This file holds reproducible shells with commands in them.

They conveniently also generate config files in their startup hook.
*/
{
  inputs,
  cell,
}: let
  inherit (inputs.std) lib;
  inherit (inputs.nixpkgs) system;
in {
  # Tool Homepage: https://numtide.github.io/devshell/
  default = inputs.devenv.lib.mkShell {
    inherit inputs;
    pkgs = inputs.nixpkgs;
    modules = [
      ({
        pkgs,
        config,
        ...
      }: let
        mach-nix = import inputs.mach-nix {
          inherit pkgs;
          python = "python39";
        };
      in {
        # This is your devenv configuration
        packages = with pkgs; [
          #libGL
          #zlib
          #glib
          #stdenv.cc.cc.lib
          pam
          #config.languages.python.package.pkgs.tkinter
          #config.languages.python.package.pkgs.pyqt5
          #config.languages.python.package.pkgs.pyqtgraph
          #inputs.cells.lidar.FastestRplidar
          #swig
          #gpp
          gccMultiStdenv
          #gnumake
          #inputs.cells.rplidar_sdk.package
        ];
        languages.python = {
          enable = true;
          poetry.enable = true;
          poetry.activate.enable = true;
          poetry.install.installRootPackage = true;
          venv.enable = true;
          package = mach-nix.mkPython {
            requirements = ''
              numpy
              pandas
              einops
            '';
            packagesExtra = [inputs.FastestRPLidar.packages.default];
          };
        };
        #env.QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins/platforms";
        #env.LD_LIBRARY_PATH = config.devenv.dotfile + "/profile/lib";
      })
    ];
  };
}

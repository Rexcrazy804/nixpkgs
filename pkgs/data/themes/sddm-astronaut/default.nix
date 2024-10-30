{ pkgs, lib, stdenvNoCC, themeConfig ? null }:
stdenvNoCC.mkDerivation rec {
  pname = "sddm-astronaut";
  version = "1.1";

  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "2bb6702a5ddc9417aadbebd6d66aae14973e47ea";
    hash = "sha256-F2I50TxGlKflHrRnmBxmiFOTzbCp/IBcHvzFf5GPXTY=";
  };

  dontWrapQtApps = true;
  propagatedBuildInputs = with pkgs.kdePackages; [ qt5compat qtsvg ];

  installPhase =
    let
      iniFormat = pkgs.formats.ini { };
      configFile = iniFormat.generate "" { General = themeConfig; };

      basePath = "$out/share/sddm/themes/sddm-astronaut-theme";
    in
    ''
      mkdir -p ${basePath}
      cp -r $src/* ${basePath}
    '' + lib.optionalString (themeConfig != null) ''
      ln -sf ${configFile} ${basePath}/theme.conf.user
    '';

  meta = {
    description = "Modern looking qt6 sddm theme";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = lib.licenses.gpl3;

    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ danid3v ];
  };
}

{ lib, fetchFromGitHub, xorg, libsForQt5, wrapQtAppsHook, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "lenovo-legion-app";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "johnfanv2";
    repo = "LenovoLegionLinux";
    rev = "v${version}";
    hash = "sha256-AnXhBhc0M1A4XnBO5HNLsH14ssfMLxG9T/qIUE3y5Tk=";
  };

  sourceRoot = "${src.name}/python/legion_linux";

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3.pkgs; [
    pyqt5
    pyqt6
    argcomplete
    pyyaml
    darkdetect
    xorg.libxcb
    libsForQt5.qtbase
  ];

  postPatch = ''
    substituteInPlace ./setup.cfg \
      --replace-warn "_VERSION" "${version}"
    substituteInPlace ./legion_linux/legion.py \
      --replace-warn "/etc/legion_linux" "$out/share/legion_linux"
    substituteInPlace ./legion_linux/legion_gui.desktop \
      --replace-warn "Icon=/usr/share/pixmaps/legion_logo.png" "Icon=legion_logo"
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
    description = "An utility to control Lenovo Legion laptop";
    homepage = "https://github.com/johnfanv2/LenovoLegionLinux";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.ulrikstrid ];
    mainProgram = "legion_gui";
  };
}


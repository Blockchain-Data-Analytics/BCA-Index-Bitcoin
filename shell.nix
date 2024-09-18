
with import <nixpkgs> {};

stdenv.mkDerivation rec {
    name = "env";

    #src = ./.;

    # Customizable development requirements
    nativeBuildInputs = [
        cmake
        git
        gnused
        gcc
        opam m4
        pkg-config
        gnumake
        autoconf automake libtool
        curl
        tmux
    ];

    buildInputs = [
        openssl
        zlib
        boost
    ];

    shellHook = ''
      echo 'nixified environment'
    '';

}


{ nixpkgs ? import <nixpkgs> {}
}:
let
  inherit (nixpkgs) pkgs;

  revealjs = pkgs.fetchFromGitHub {
    owner = "hakimel";
    repo = "reveal.js";
    rev = "43eada79901830702bd40dce857831aef8e76759";
    sha256 = "5be5c1b831e0f4a4f955f76340c2d08c8a1a57c5be5dd68592fd5be511e76bda";
  };

  local = ./.;
in
  pkgs.stdenv.mkDerivation {
    name = "your-first-haskell-app";
    src = ./.;

    unpackPhase = ''
      mkdir -p $name/{reveal.js,css,images,js}
      cd $name
      cp -r ${revealjs}/* ./reveal.js/
      cp $src/css/* ./css/
      # rm ./css/grid-light.css
      cp $src/images/* ./images/
    '';

    buildPhase = ''
      cat $src/slides/title.md \
          $src/slides/intro.md \
          $src/slides/overview.md \
          $src/slides/the-app.md \
          $src/slides/concepts.md \
          $src/slides/types.md \
          $src/slides/data-flow.md \
          $src/slides/configuration.md \
          $src/slides/optparse.md \
          $src/slides/db.md \
          $src/slides/the-end.md \
          > slides.md
      pandoc -t revealjs --template=$src/template.revealjs --variable=codedir:$out --variable=transition:none --highlight-style=zenburn -s slides.md -o index.html
      rm slides.md
    '';

    installPhase = ''
      mkdir $out
      cp -r ./* $out/
    '';

    phases = ["unpackPhase" "buildPhase" "installPhase"];

    buildInputs = [pkgs.pandoc];
  }

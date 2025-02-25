{ pkgs, ... }: {
  channel = "stable-23.11";

  packages = [
    pkgs.python3
    pkgs.python3Packages.virtualenv
    pkgs.python3Packages.pip
    pkgs.zrok
  ];

  env = {
    VENV_DIR = ".venv";
    MAIN_FILE = "src/main.py";
  };

  idx = {
    extensions = [
      "ms-python.python"
      "ms-python.debugpy"
      "charliermarsh.ruff"
    ];

    workspace = {
      onCreate = {
        create-venv = ''
          python -m venv $VENV_DIR
          source $VENV_DIR/bin/activate
          pip install "flet[all]" --upgrade --quiet
        '';

        default.openFiles = [ "README.md" "pyproject.toml" "$MAIN_FILE" ];
      };

      onStart = {
        check-venv-existence = ''
          source $VENV_DIR/bin/activate
          pip install "flet[all]" --upgrade --quiet
        '';
        
        default.openFiles = [ "README.md" "pyproject.toml" "$MAIN_FILE" ];
      };
    };

    previews = {
      enable = true;
      previews = {
        web = {
          command = [
            "bash" "-c" 
            ''
              source $VENV_DIR/bin/activate
              flet run $MAIN_FILE --web --port $PORT
            ''
          ];
          manager = "web";
        };
      };
    };
  };
}
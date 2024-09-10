# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # nixpkgs channel
  channel = "stable-23.11";

  packages = [
    pkgs.python3
    pkgs.jdk20
  ];

  # environment variables
  env = {
    VENV_DIR = ".venv";
    MAIN_FILE = "main.py";
  };

  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "ms-python.python"
      "ms-python.debugpy"
    ];

    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        # create a python virtual environment
        create-venv = ''
          python -m venv $VENV_DIR

          if [ ! -f requirements.txt ]; then
            echo "requirements.txt not found. Creating one with flet..."
            echo "flet" > requirements.txt
          fi

          # activate virtual env and install requirements
          source $VENV_DIR/bin/activate
          pip install -r requirements.txt
        '';

        # Open editors for the following files by default, if they exist:
        default.openFiles = [ "README.md" "requirements.txt" "$MAIN_FILE" ];
      };

      onStart = {
        # check the existence of the venv and create if non-existent
        check-venv-existence = ''
          if [ ! -d $VENV_DIR ]; then
            echo "Virtual environment not found. Creating one..."
            python -m venv $VENV_DIR
          fi

          if [ ! -f requirements.txt ]; then
            echo "requirements.txt not found. Creating one with flet..."
            echo "flet" > requirements.txt
          fi

          # activate virtual env and install requirements
          source $VENV_DIR/bin/activate
          pip install -r requirements.txt
        '';

        # Open editors for the following files by default, if they exist:
        default.openFiles = [ "README.md" "requirements.txt" "$MAIN_FILE" ];
      };
    };

    # Enable web preview
    previews = {
      enable = true;
      previews = {
        web = {
          # cwd = "subfolder"
          command = [
            "bash"
            "-c"
            ''
            # activate the virtual environment
            source $VENV_DIR/bin/activate
            
            # run app in hot reload mode on a port provided by IDX
            flet run $MAIN_FILE --web --port $PORT
            ''
          ];
          env = { PORT = "$PORT"; };
          manager = "web";
        };
      };
    };
  };
}

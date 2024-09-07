{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"

  packages = [ pkgs.python3 ];

  # environment variables
  env = {
    VENV_DIR = ".venv";
  };

  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [ "ms-python.python" ];

    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        # create a python virtual environment
        create-venv = ''
          python -m venv $VENV_DIR
          source $VENV_DIR/bin/activate
          
          if [ ! -f requirements.txt ]; then
            echo "requirements.txt not found. Creating one with flet..."
            echo "flet" > requirements.txt
          fi

          pip install -r requirements.txt
        '';

        # Open editors for the following files by default, if they exist:
        default.openFiles = [ "main.py" "README.md" ];
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
            flet run main.py --web --port $PORT
            ''
          ];
          env = { PORT = "$PORT"; };
          manager = "web";
        };
      };
    };
  };
}

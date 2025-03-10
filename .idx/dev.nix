# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"
  services.docker.enable = true;
  services.postgres.enable = false;
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.gnumake
  ];

  # Sets environment variables in the workspace
  env = {
    # You can get a Gemini API key through the IDX Integrations panel to the left!
  };

  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "cweijan.vscode-mysql-client2"
      "cweijan.dbclient-jdbc"
    ];

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        default.openFiles = [
          "Makefile"
        ];
        # Example: install JS dependencies from NPM
        setup = ''
          mkdir data
          wget -O data/dvdrental.tar https://raw.githubusercontent.com/salbifaza/dibimbing-sql-part-1/master/database/postgresql/dvdrental.tar
          initdb -D local
          psql --dbname=postgres -c "ALTER USER \"user\" PASSWORD 'my_password';"
          psql --dbname=postgres -c "CREATE USER postgres WITH PASSWORD 'postgres' SUPERUSER;"
          psql --dbname=postgres -c "CREATE DATABASE dvdrental;"
          pg_restore -U postgres -d dvdrental /home/user/dibimbing-sql/data/dvdrental.tar
        '';
      };
      # Runs when the workspace is (re)started
      onStart = {
        # typescript-build = "tsc";
      };
    };

    # Enable previews
    previews = {
      enable = true;
      previews = {
        # web = {
        #   # Example: run "npm run dev" with PORT set to IDX's defined port for previews,
        #   # and show it in IDX's web preview panel
        #   command = ["npm" "run" "dev"];
        #   manager = "web";
        #   env = {
        #     # Environment variables to set for your server
        #     PORT = "$PORT";
        #   };
        # };
      };
    };
  };
}

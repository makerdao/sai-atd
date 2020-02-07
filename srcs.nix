{
  pkgs = fetchGit {
    url = "https://github.com/makerdao/nixpkgs-pin";
    rev = "3cfc0aa06781e1e777778e89327078944c0412dd";
    ref = "simplify";
  };

  saiDeployScripts = fetchGit {
    url = "https://github.com/makerdao/sai-deploy-scripts";
    rev = "c49b7f4365409f1f865be0dba6a4a8d4cc9660e2";
  };
}

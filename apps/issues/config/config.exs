use Mix.Config

config :issues,
  github_url: "https://api.github.com"

import_config "#{Mix.env()}.exs"

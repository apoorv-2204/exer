import Config

config :upnpe, :src_dir, File.cwd!()

config :upnpe, :mut_dir, "data"

import_config("#{Mix.env()}.exs")

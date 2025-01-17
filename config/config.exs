import Config

config :esbuild,
  version: "0.24.2",
  default: [
    args:
      ~w(app.js --bundle --target=es2017 --outdir=../output/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.17",
  default: [
    args: ~w(--config=tailwind.config.js --input=app.css --output=../output/assets/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

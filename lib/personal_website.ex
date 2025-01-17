defmodule PersonalWebsite do
  use Phoenix.Component

  @output_dir "./output"
  File.mkdir_p!(@output_dir)

  def index(assigns) do
    ~H"""
    <.layout>
      <main class="h-screen flex flex-col bg-slate-500">
        <section class="grow flex">
          <div class="container w-[400px] m-auto">
            <h1 class="py-16 text-4xl text-neutral-100 font-serif italic">A whisper on the wind</h1>
            <div class="py-4 text-2xl text-center text-neutral-300">{<<0x2666::utf8>>}</div>
            <p class="py-6 text-xl text-center text-neutral-200">Check back soon</p>
          </div>
        </section>
        <footer class="py-4">
          <div class="text-center text-neutral-200 tracking-wider">
            {<<0x00A9::utf8>>} {DateTime.utc_now() |> Map.fetch!(:year)} Krishan Wyse
          </div>
        </footer>
      </main>
    </.layout>
    """
  end

  def layout(assigns) do
    ~H"""
    <html>
      <meta charset="utf-8" />
      <link rel="stylesheet" href="/assets/app.css" />
      <script type="text/javascript" src="/assets/app.js" />
      <body>
        {render_slot(@inner_block)}
      </body>
    </html>
    """
  end

  def build do
    render_file("index.html", index(%{}))
  end

  def render_file(path, rendered) do
    safe = Phoenix.HTML.Safe.to_iodata(rendered)
    output = Path.join([@output_dir, path])
    File.write!(output, safe)
  end
end

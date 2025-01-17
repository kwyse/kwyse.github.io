defmodule PersonalWebsite do
  use Phoenix.Component

  @output_dir "./output"
  File.mkdir_p!(@output_dir)

  def index(assigns) do
    ~H"""
    <.layout>
      <h1 class="underline">Krishan Wyse</h1>
    </.layout>
    """
  end

  def layout(assigns) do
    ~H"""
    <html>
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

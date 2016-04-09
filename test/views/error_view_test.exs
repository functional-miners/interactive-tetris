defmodule InteractiveTetris.ErrorViewTest do
  use InteractiveTetris.ConnCase, async: true

  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(InteractiveTetris.ErrorView, "404.html", []) == "Page not found"
  end

  test "render 500.html" do
    assert render_to_string(InteractiveTetris.ErrorView, "500.html", []) == "Server internal error"
  end

  test "render any other" do
    assert render_to_string(InteractiveTetris.ErrorView, "505.html", []) == "Server internal error"
  end
end

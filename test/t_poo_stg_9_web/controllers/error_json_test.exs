defmodule TPooStg9Web.ErrorJSONTest do
  use TPooStg9Web.ConnCase, async: true

  test "renders 404" do
    assert TPooStg9Web.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert TPooStg9Web.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end

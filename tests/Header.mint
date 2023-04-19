suite "Header" {
  test "it has a logo" {
    <Header/>
    |> Test.Html.start()
    |> Test.Html.assertElementExists("[data-selector=brand] svg")
  }

  test "it has a brand name" {
    <Header/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("span", "Conduit")
  }

  test "it renders the sign in link" {
    <Header/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("div[data-selector=links] a:first-child", "Sign in")
  }

  test "it renders the sign up link" {
    <Header/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("div[data-selector=links] a:last-child", "Sign up")
  }
}

component Articles {
  property status : Api.Status(Array(Article)) = Api.Status::Initial

  get articles : Array(Html) {
    status
    |> Api.withDefault([])
    |> Array.map(
      (article : Article) : Html => { <Article.Preview article={article}/> })
    |> Array.intersperse(<div::divider/>)
  }

  style divider {
    margin: 20px 0;
  }

  fun render : Html {
    <Status
      message="There was an error loading the articles."
      loadingMessage="Loading articles..."
      status={status}>

      <{ articles }>

    </Status>
  }
}

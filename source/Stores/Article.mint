store Stores.Article {
  state status : Api.Status(Article) = Api.Status.Initial

  get article : Article {
    Api.withDefault(Article.empty(), status)
  }

  fun set (article : Article) : Promise(Void) {
    next { status: Api.Status.Ok(article) }
  }

  fun reset : Promise(Void) {
    next { status: Api.Status.Initial }
  }

  fun load (slug : String) : Promise(Void) {
    await next { status: Api.Status.Loading }

    let newStatus =
      "/articles/" + slug
      |> Http.get()
      |> Api.send(Article.fromResponse)

    next { status: await newStatus }
  }
}

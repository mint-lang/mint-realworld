/* This store contains the data of the currently viewed article. */
store Stores.Article {
  /* Represents the status of the article. */
  state status : Api.Status(Article) = Api.Status.Initial

  /* Returns the current article. */
  get article : Article {
    Api.withDefault(Article.empty(), status)
  }

  fun set (article : Article) : Promise(Void) {
    next { status: Api.Status.Ok(article) }
  }

  /* Resets the store to the initial values. */
  fun reset : Promise(Void) {
    next { status: Api.Status.Initial }
  }

  /* Loads the article from the given slug. */
  fun load (slug : String) : Promise(Void) {
    await next { status: Api.Status.Loading }

    let newStatus =
      await "/articles/" + slug
      |> Http.get()
      |> Api.send(Article.fromResponse)

    await next { status: newStatus }
  }
}

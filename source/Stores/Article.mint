/* This store contains the data of the currenty viewed article. */
store Stores.Article {
  /* Represents the status of the article. */
  state status : Api.Status(Article) = Api.Status::Initial

  /* Returns the current article. */
  get article : Article {
    Api.withDefault(Article.empty(), status)
  }

  fun set (article : Article) : Promise(Never, Void) {
    next { status = Api.Status::Ok(article) }
  }

  /* Resets the store to the initial values. */
  fun reset : Promise(Never, Void) {
    next { status = Api.Status::Initial }
  }

  /* Loads the article from the given slug. */
  fun load (slug : String) : Promise(Never, Void) {
    sequence {
      next { status = Api.Status::Loading }

      newStatus =
        Http.get("/articles/" + slug)
        |> Api.send(Article.fromResponse)

      next { status = newStatus }
    }
  }
}

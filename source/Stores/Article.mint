/* This store contains the data of the currenty viewed article. */
store Stores.Article {
  /* Represents the status of the article. */
  state status : Api.Status(Article) = Api.Status::Initial

  /* Returns the current article. */
  get article : Article {
    Api.withDefault(Article.empty(), status)
  }

  /* Resets the store to the initial values. */
  fun reset : Promise(Never, Void) {
    next { status = Api.Status::Initial }
  }

  /* Loads the article from the given slug. */
  fun load (slug : String) : Promise(Never, Void) {
    /* If the slug is the same then we don't need to do anything. */
    if (article.slug == slug) {
      Promise.never()
    } else {
      /* If the next article is in the store we just use that. */
      if (nextArticle.slug == slug) {
        next { status = Api.Status::Ok(nextArticle) }
      } else {
        sequence {
          next { status = Api.nextStatus(status) }

          status =
            Api.endpoint() + "/articles/" + slug
            |> Http.get()
            |> Api.send(
              (object : Object) : Result(Object.Error, Article) => {
                Object.Decode.field(
                  "article",
                  (input : Object) : Result(Object.Error, Article) => { decode input as Article },
                  object)
              })

          next { status = status }
        }
      }
    }
  } where {
    nextArticle =
      Stores.Articles.articles
      |> Array.find(
        (article : Article) : Bool => { article.slug == slug })
      |> Maybe.withDefault(Article.empty())
  }
}

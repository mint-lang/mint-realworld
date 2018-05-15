store Stores.Article {
  property status : Api.Status = Api.Status::Initial
  property article : Article = Article.empty()
  property slug : String = ""

  fun reset : Void {
    next { state | status = Api.Status::Initial }
  }

  fun load (newSlug : String) : Void {
    if (newSlug == slug) {
      void
    } else {
      if (article.slug == newSlug) {
        next
          { state |
            status = Api.Status::Ok,
            article = article
          }
      } else {
        do {
          next { state | status = Api.nextStatus(status) }

          article =
            Api.endpoint() + "/articles/" + newSlug
            |> Http.get()
            |> Api.send(
              \object : Object => Object.Decode.field("article", Article.decode, object))

          next
            { state |
              status = Api.Status::Ok,
              slug = newSlug,
              article = article
            }
        } catch Api.Status => status {
          next { state | status = status }
        }
      }
    }
  } where {
    article =
      Stores.Articles.articles
      |> Array.find(\article : Article => article.slug == newSlug)
      |> Maybe.withDefault(Article.empty())
  }
}

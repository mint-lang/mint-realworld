store Stores.Article {
  property status : Api.Status = Api.Status::Initial
  property article : Article = Article.empty()
  property slug : String = ""

  fun reset : Void {
    next
      { state |
        status = Api.Status::Initial,
        article = Article.empty(),
        slug = ""
      }
  }

  fun load (newSlug : String) : Void {
    if (slug == newSlug) {
      void
    } else {
      if (article.slug == newSlug) {
        next
          { state |
            status = Api.Status::Ok,
            article = article,
            slug = newSlug
          }
      } else {
        do {
          next { state | status = Api.nextStatus(status) }

          article =
            Api.endpoint() + "/articles/" + newSlug
            |> Http.get()
            |> Api.send(Article.decodeArticle)

          next
            { state |
              status = Api.Status::Ok,
              article = article,
              slug = newSlug
            }
        } catch Api.Status => status {
          reset()
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

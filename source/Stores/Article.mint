store Stores.Article {
  state status : Api.Status = Api.Status::Initial
  state article : Article = Article.empty()
  state slug : String = ""

  fun reset : Void {
    next
      {
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
          {
            status = Api.Status::Ok,
            article = article,
            slug = newSlug
          }
      } else {
        do {
          next { status = Api.nextStatus(status) }

          article =
            Api.endpoint() + "/articles/" + newSlug
            |> Http.get()
            |> Api.send(
              (object : Object) : Result(Object.Error, Article) => {
                Object.Decode.field(
                  "article",
                  (input : Object) : Result(Object.Error, Article) => { decode input as Article },
                  object)
              })

          next
            {
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
      |> Array.find(
        (article : Article) : Bool => { article.slug == newSlug })
      |> Maybe.withDefault(Article.empty())
  }
}

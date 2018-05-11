store Stores.Article {
  property article : Article = Article.empty()
  property loading : Bool = false

  fun load (slug : String) : Void {
    if (article.slug == slug) {
      next { state | article = article }
    } else {
      with Http {
        do {
          next { state | loading = true }

          response =
            get(Api.endpoint() + "/articles/" + slug)
            |> send()

          object =
            Json.parse(response.body)
            |> Maybe.toResult("")

          article =
            Object.Decode.field("article", Article.decode, object)

          next { state | article = article }
        } catch Http.ErrorResponse => error {
          void
        } catch Object.Error => error {
          void
        } catch String => error {
          void
        } finally {
          next { state | loading = false }
        }
      }
    }
  } where {
    article =
      Stores.Articles.articles
      |> Array.find(\article : Article => article.slug == slug)
      |> Maybe.withDefault(Article.empty())
  }
}

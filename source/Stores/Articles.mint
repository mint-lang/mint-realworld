record Param {
  param : String,
  value : String
}

store Stores.Articles {
  property tag : Maybe(String) = Maybe.nothing()
  property articles : Array(Article) = []
  property loading : Bool = false
  property cached : Bool = true

  fun load (tag : Maybe(String)) : Void {
    do {
      next
        { state |
          loading = true,
          tag = tag
        }

      tagParams =
        [
          {
            param = "tag",
            value = Maybe.withDefault("", tag)
          }
        ]

      params =
        tagParams
        |> Array.reject(\item : Param => String.isEmpty(item.value))
        |> Array.map(\item : Param => item.param + "=" + item.value)
        |> String.join("&")

      response =
        Http.get(Api.endpoint() + "/articles?" + params)
        |> Http.send()

      object =
        Json.parse(response.body)
        |> Maybe.toResult("")

      articles =
        Object.Decode.field("articles", Article.decodeMany, object)

      next { state | articles = articles }
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

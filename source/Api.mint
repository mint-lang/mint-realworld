module Api {
  fun endpoint : String {
    "https://conduit.productionready.io/api"
  }
}

store Articles {
  property articles : Array(Article) = []
  property loading : Bool = false

  fun load : Void {
    with Http {
      do {
        next { state | loading = true }

        response =
          get(Api.endpoint() + "/articles")
          |> send()

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
}

routes {
  / {
    Articles.load()
  }
}

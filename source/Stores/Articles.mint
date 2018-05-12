module SearchParams {
  fun empty : SearchParams {
    `new URLSearchParams()`
  }

  fun append (key : String, value : String, params : SearchParams) : SearchParams {
    `
    (() => {
      params.append(key, value)
      return params
    })()
    `
  }

  fun toString (params : SearchParams) : String {
    `params.toString()`
  }
}

record Stores.Articles.Params {
  tag : Maybe(String)
}

store Stores.Articles {
  property status : Api.Status = Api.Status::Initial
  property articles : Array(Article) = []

  property params : Stores.Articles.Params = { tag = Maybe.nothing() }

  fun load (newParams : Stores.Articles.Params) : Void {
    if (newParams == params && status != Api.Status::Initial) {
      void
    } else {
      do {
        next { state | status = Api.nextStatus(status) }

        params =
          SearchParams.empty()
          |> SearchParams.append(
            "tag",
            Maybe.withDefault("", newParams.tag))
          |> SearchParams.toString()

        articles =
          Http.get(Api.endpoint() + "/articles?" + params)
          |> Api.send(
            \object : Object => Object.Decode.field("articles", Article.decodeMany, object))

        next
          { state |
            status = Api.Status::Ok,
            articles = articles,
            params = newParams
          }
      } catch Api.Status => status {
        next { state | status = status }
      }
    }
  }
}

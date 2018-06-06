record Stores.Articles.Params {
  limit : Number,
  tag : String
}

store Stores.Articles {
  property status : Api.Status = Api.Status::Initial
  property articles : Array(Article) = []

  property params : Stores.Articles.Params = {
    tag = "",
    limit = 10
  }

  fun reset : Void {
    next
      { state |
        status = Api.Status::Initial,
        articles = []
      }
  }

  fun load (newParams : Stores.Articles.Params) : Void {
    if (newParams == params && status != Api.Status::Initial) {
      void
    } else {
      do {
        next
          { state |
            status = Api.nextStatus(status),
            params = newParams
          }

        params =
          SearchParams.empty()
          |> SearchParams.append("tag", newParams.tag)
          |> SearchParams.append("limit", Number.toString(newParams.limit))
          |> SearchParams.toString()

        articles =
          Http.get(Api.endpoint() + "/articles?" + params)
          |> Api.send(
              \object : Object =>
                Object.Decode.field(
                  "articles",
                  \input : Object => decode input as Array(Article),
                  object))

        next
          { state |
            status = Api.Status::Ok,
            articles = articles
          }
      } catch Api.Status => status {
        next { state | status = status }
      }
    }
  }
}

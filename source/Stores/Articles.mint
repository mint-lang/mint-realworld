record Stores.Articles.Params {
  limit : Number,
  tag : String
}

store Stores.Articles {
  state status : Api.Status = Api.Status::Initial
  state articles : Array(Article) = []

  state params : Stores.Articles.Params = {
    tag = "",
    limit = 10
  }

  fun reset : Void {
    next
      {
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
          {
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
            (object : Object) : Result(Object.Error, Array(Article)) => {
              Object.Decode.field(
                "articles",
                (input : Object) : Result(Object.Error, Array(Article)) => { decode input as Array(Article) },
                object)
            })

        next
          {
            status = Api.Status::Ok,
            articles = articles
          }
      } catch Api.Status => status {
        next { status = status }
      }
    }
  }
}

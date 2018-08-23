record Stores.Articles.Params {
  limit : Number,
  tag : String
}

store Stores.Articles {
  state status : Api.Status(Array(Article)) = Api.Status::Initial

  state params : Stores.Articles.Params = {
    limit = 10,
    tag = ""
  }

  get articles : Array(Article) {
    Api.withDefault([], status)
  }

  fun reset : Promise(Never, Void) {
    next { status = Api.Status::Initial }
  }

  fun load (newParams : Stores.Articles.Params) : Promise(Never, Void) {
    if (newParams == params && status != Api.Status::Initial) {
      Promise.never()
    } else {
      sequence {
        next
          {
            status = Api.Status::Loading,
            params = newParams
          }

        params =
          SearchParams.empty()
          |> SearchParams.append("tag", newParams.tag)
          |> SearchParams.append("limit", Number.toString(newParams.limit))
          |> SearchParams.toString()

        status =
          Http.get(Api.endpoint() + "/articles?" + params)
          |> Api.send(
            (object : Object) : Result(Object.Error, Array(Article)) => {
              Object.Decode.field(
                "articles",
                (input : Object) : Result(Object.Error, Array(Article)) => { decode input as Array(Article) },
                object)
            })

        next { status = status }
      }
    }
  }
}

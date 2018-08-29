record Stores.Articles.Params {
  author : String,
  limit : Number,
  tag : String
}

store Stores.Articles {
  state status : Api.Status(Array(Article)) = Api.Status::Initial

  state params : Stores.Articles.Params = {
    author = "",
    limit = 10,
    tag = ""
  }

  get articles : Array(Article) {
    Api.withDefault([], status)
  }

  fun reset : Promise(Never, Void) {
    next { status = Api.Status::Initial }
  }

  fun replaceArticle (article : Article) : Promise(Never, Void) {
    next { status = nextStatus }
  } where {
    nextStatus =
      case (status) {
        Api.Status::Ok articles =>
          Api.Status::Ok(Array.map(
            (item : Article) : Article => {
              if (item.slug == article.slug) {
                article
              } else {
                item
              }
            },
            articles))

        => status
      }
  }

  fun load (newParams : Stores.Articles.Params) : Promise(Never, Void) {
    sequence {
      next
        {
          status = Api.Status::Loading,
          params = newParams
        }

      params =
        SearchParams.empty()
        |> SearchParams.append("author", newParams.author)
        |> SearchParams.append("tag", newParams.tag)
        |> SearchParams.append("limit", Number.toString(newParams.limit))
        |> SearchParams.toString()

      status =
        Http.get("/articles?" + params)
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

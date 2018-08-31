record Stores.Articles.Params {
  author : String,
  limit : Number,
  page : Number,
  tag : String
}

record Stores.Articles {
  count : Number using "articlesCount",
  articles : Array(Article)
}

store Stores.Articles {
  state status : Api.Status(Stores.Articles) = Api.Status::Initial

  state params : Stores.Articles.Params = {
    author = "",
    limit = 10,
    page = 0,
    tag = ""
  }

  fun reset : Promise(Never, Void) {
    next { status = Api.Status::Initial }
  }

  fun replaceArticle (article : Article) : Promise(Never, Void) {
    next { status = nextStatus }
  } where {
    nextStatus =
      case (status) {
        Api.Status::Ok data =>
          try {
            articles =
              Array.map(
                (item : Article) : Article => {
                  if (item.slug == article.slug) {
                    article
                  } else {
                    item
                  }
                },
                data.articles)

            Api.Status::Ok({ data | articles = articles })
          }

        => status
      }
  }

  fun load (author : String, rawPage : String, tag : String) : Promise(Never, Void) {
    sequence {
      page =
        Number.fromString(rawPage)
        |> Maybe.withDefault(1)
        |> Math.max(1)

      next
        {
          status = Api.Status::Loading,
          params =
            { params |
              author = author,
              page = page - 1,
              tag = tag
            }
        }

      limit =
        Number.toString(params.limit)

      offset =
        Number.toString(params.page * params.limit)

      params =
        SearchParams.empty()
        |> SearchParams.append("author", params.author)
        |> SearchParams.append("tag", params.tag)
        |> SearchParams.append("offset", offset)
        |> SearchParams.append("limit", limit)
        |> SearchParams.toString()

      status =
        Http.get("/articles?" + params)
        |> Api.send(
          (object : Object) : Result(Object.Error, Stores.Articles) => { decode object as Stores.Articles })

      next { status = status }
    }
  }
}

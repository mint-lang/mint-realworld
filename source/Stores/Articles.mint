record Stores.Articles.Params {
  favorited : Bool,
  author : String,
  limit : Number,
  page : Number,
  tag : String,
  feed : Bool
}

record Stores.Articles {
  count : Number using "articlesCount",
  articles : Array(Article)
}

store Stores.Articles {
  state status : Api.Status(Stores.Articles) = Api.Status::Initial

  state params : Stores.Articles.Params = {
    favorited = false,
    feed = false,
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
        Api.Status::Ok(data) =>
          try {
            articles =
              Array.map(
                (item : Article) : Article {
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

  fun load (
    author : String,
    rawPage : String,
    tag : String,
    feed : Bool,
    favorited : Bool
  ) : Promise(Never, Void) {
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
              favorited = favorited,
              author = author,
              page = page - 1,
              feed = feed,
              tag = tag
            }
        }

      limit =
        Number.toString(params.limit)

      offset =
        Number.toString(params.page * params.limit)

      favoritedValue =
        if (params.favorited) {
          params.author
        } else {
          ""
        }

      search =
        SearchParams.empty()
        |> SearchParams.append("favorited", favoritedValue)
        |> SearchParams.append("author", params.author)
        |> SearchParams.append("tag", params.tag)
        |> SearchParams.append("offset", offset)
        |> SearchParams.append("limit", limit)
        |> SearchParams.toString()

      request =
        if (params.feed) {
          Http.get("/articles/feed?" + search)
        } else {
          Http.get("/articles?" + search)
        }

      newStatus =
        Api.send(
          (object : Object) : Result(Object.Error, Stores.Articles) { decode object as Stores.Articles },
          request)

      next { status = newStatus }
    }
  }
}

type Stores.Articles.Params {
  favorited : Bool,
  author : String,
  limit : Number,
  page : Number,
  tag : String,
  feed : Bool
}

type Stores.Articles {
  count : Number using "articlesCount",
  articles : Array(Article)
}

store Stores.Articles {
  state status : Api.Status(Stores.Articles) = Api.Status.Initial

  state params : Stores.Articles.Params =
    {
      favorited: false,
      feed: false,
      author: "",
      limit: 10,
      page: 0,
      tag: ""
    }

  fun reset : Promise(Void) {
    next { status: Api.Status.Initial }
  }

  fun replaceArticle (article : Article) : Promise(Void) {
    let nextStatus =
      if let Api.Status.Ok(data) = status {
        let articles =
          Array.map(
            data.articles,
            (item : Article) : Article {
              if item.slug == article.slug {
                article
              } else {
                item
              }
            })

        Api.Status.Ok({ data | articles: articles })
      } else {
        status
      }

    next { status: nextStatus }
  }

  fun load (
    author : String,
    rawPage : String,
    tag : String,
    feed : Bool,
    favorited : Bool
  ) : Promise(Void) {
    let page =
      Number.fromString(rawPage)
      |> Maybe.withDefault(1)
      |> Math.max(1)

    await next
      {
        status: Api.Status.Loading,
        params:
          { params |
            favorited: favorited,
            author: author,
            page: page - 1,
            feed: feed,
            tag: tag
          }
      }

    let limit =
      Number.toString(params.limit)

    let offset =
      Number.toString(params.page * params.limit)

    let favoritedValue =
      if params.favorited {
        params.author
      } else {
        ""
      }

    let search =
      SearchParams.empty()
      |> SearchParams.appendNotBlank("favorited", favoritedValue)
      |> SearchParams.appendNotBlank("author", params.author)
      |> SearchParams.appendNotBlank("tag", params.tag)
      |> SearchParams.appendNotBlank("offset", offset)
      |> SearchParams.appendNotBlank("limit", limit)
      |> SearchParams.toString()

    let request =
      if params.feed {
        Http.get("/articles/feed?" + search)
      } else {
        Http.get("/articles?" + search)
      }

    let newStatus =
      await Api.send(
        request,
        decode as Stores.Articles)

    await next { status: newStatus }
  }
}

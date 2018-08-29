/* This store contains the data of the currenty viewed article. */
store Stores.Article {
  state favoriteStatus : Api.Status(Article) = Api.Status::Initial
  state createStatus : Api.Status(Article) = Api.Status::Initial

  /* Represents the status of the article. */
  state status : Api.Status(Article) = Api.Status::Initial

  /* Returns the current article. */
  get article : Article {
    Api.withDefault(Article.empty(), status)
  }

  fun decodeArticle (object : Object) : Result(Object.Error, Article) {
    Object.Decode.field(
      "article",
      (input : Object) : Result(Object.Error, Article) => { decode input as Article },
      object)
  }

  /* Resets the store to the initial values. */
  fun reset : Promise(Never, Void) {
    next
      {
        status = Api.Status::Initial,
        createStatus = Api.Status::Initial
      }
  }

  fun toggleFavorite (article : Article) : Promise(Never, Void) {
    sequence {
      next { favoriteStatus = Api.Status::Loading }

      url =
        "/articles/" + article.slug + "/favorite"

      request =
        if (article.favorited) {
          Http.delete(url)
        } else {
          Http.post(url)
        }

      nextStatus =
        Api.send(decodeArticle, request)

      next { favoriteStatus = nextStatus }

      case (nextStatus) {
        Api.Status::Ok updatedArticle =>
          parallel {
            Stores.Articles.replaceArticle(updatedArticle)

            case (status) {
              Api.Status::Ok currentArticle =>
                if (updatedArticle.slug == currentArticle.slug) {
                  next { status = nextStatus }
                } else {
                  Promise.never()
                }

              => Promise.never()
            }
          }

        => Promise.never()
      }
    }
  }

  fun create (
    title : String,
    extract : String,
    content : String,
    tags : Set(String)
  ) : Promise(Never, Void) {
    sequence {
      next { createStatus = Api.Status::Loading }

      body =
        encode {
          article =
            {
              tagList = Set.toArray(tags),
              description = extract,
              title = title,
              body = content
            }
        }

      status =
        Http.post("/articles")
        |> Http.jsonBody(body)
        |> Api.send(decodeArticle)

      next { createStatus = status }

      case (status) {
        Api.Status::Ok article =>
          sequence {
            Window.navigate("/article/" + article.slug)
          }

        => Promise.never()
      }
    }
  }

  /* Loads the article from the given slug. */
  fun load (slug : String) : Promise(Never, Void) {
    /* If the slug is the same then we don't need to do anything. */
    if (article.slug == slug) {
      Promise.never()
    } else {
      /* If the next article is in the store we just use that. */
      if (nextArticle.slug == slug) {
        next { status = Api.Status::Ok(nextArticle) }
      } else {
        sequence {
          next { status = Api.Status::Loading }

          status =
            Http.get("/articles/" + slug)
            |> Api.send(decodeArticle)

          next { status = status }
        }
      }
    }
  } where {
    nextArticle =
      Stores.Articles.articles
      |> Array.find(
        (article : Article) : Bool => { article.slug == slug })
      |> Maybe.withDefault(Article.empty())
  }
}

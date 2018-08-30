/* This store contains the data of the currenty viewed article. */
store Stores.Article {
  state favoriteStatus : Api.Status(Article) = Api.Status::Initial
  state deleteStatus : Api.Status(Void) = Api.Status::Initial

  /* Represents the status of the article. */
  state status : Api.Status(Article) = Api.Status::Initial

  /* Returns the current article. */
  get article : Article {
    Api.withDefault(Article.empty(), status)
  }

  /* Resets the store to the initial values. */
  fun reset : Promise(Never, Void) {
    next { status = Api.Status::Initial }
  }

  fun destroy (slug : String) : Promise(Never, Void) {
    sequence {
      next { deleteStatus = Api.Status::Loading }

      status =
        Http.delete("/articles/" + slug)
        |> Api.send(
          (object : Object) : Result(Object.Error, Void) => { Result.ok(void) })

      case (status) {
        Api.Status::Ok => Window.navigate("/")
        => next { deleteStatus = status }
      }
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
        Api.send(Article.fromResponse, request)

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

  /* Loads the article from the given slug. */
  fun load (slug : String) : Promise(Never, Void) {
    sequence {
      next { status = Api.Status::Loading }

      status =
        Http.get("/articles/" + slug)
        |> Api.send(Article.fromResponse)

      next { status = status }
    }
  }
}

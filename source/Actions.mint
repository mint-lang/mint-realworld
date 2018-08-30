store Actions {
  fun toggleUserFollow (profile : Author) : Promise(Never, Api.Status(Author)) {
    sequence {
      url =
        "/profiles/" + profile.username + "/follow"

      request =
        if (profile.following) {
          Http.delete(url)
        } else {
          Http.post(url)
        }

      status =
        Api.send(Author.fromResponse, request)
    }
  }

  fun deleteArticle (slug : String) : Promise(Never, Void) {
    sequence {
      status =
        Http.delete("/articles/" + slug)
        |> Api.send(
          (object : Object) : Result(Object.Error, Void) => { Result.ok(void) })

      case (status) {
        Api.Status::Ok => Window.navigate("/")
        => Promise.never()
      }
    }
  }

  fun toggleFavorite (article : Article) : Promise(Never, Void) {
    sequence {
      url =
        "/articles/" + article.slug + "/favorite"

      request =
        if (article.favorited) {
          Http.delete(url)
        } else {
          Http.post(url)
        }

      status =
        Api.send(Article.fromResponse, request)

      case (status) {
        Api.Status::Ok article => Stores.Articles.replaceArticle(article)

        => Promise.never()
      }
    }
  }
}

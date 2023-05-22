store Actions {
  fun toggleUserFollow (profile : Author) : Promise(Api.Status(Author)) {
    let url =
      "/profiles/" + profile.username + "/follow"

    let request =
      if profile.following or false {
        Http.delete(url)
      } else {
        Http.post(url)
      }

    Api.send(request, Author.fromResponse)
  }

  fun deleteArticle (slug : String) : Promise(Void) {
    await Window.confirm("Are you sure?")

    let status =
      await Http.delete("/articles/" + slug)
      |> Api.send((object : Object) { Result.ok(void) })

    case status {
      Api.Status::Ok => Window.navigate("/")
      => next { }
    }
  }

  fun toggleFavorite (article : Article) : Promise(Void) {
    let url =
      "/articles/" + article.slug + "/favorite"

    let request =
      if article.favorited {
        Http.delete(url)
      } else {
        Http.post(url)
      }

    let status =
      await Api.send(request, Article.fromResponse)

    await case status {
      Api.Status::Ok(article) => Stores.Articles.replaceArticle(article)
      => next { }
    }
  }
}

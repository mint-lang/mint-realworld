store Forms.Article {
  state status : Api.Status(Article) = Api.Status::Initial

  state slug : Maybe(String) = Maybe.nothing()
  state tags : Set(String) = Set.empty()
  state extract : String = ""
  state content : String = ""
  state title : String = ""

  fun reset : Promise(Never, Void) {
    next
      {
        slug = Maybe.nothing(),
        tags = Set.empty(),
        extract = "",
        content = "",
        title = ""
      }
  }

  fun set (article : Article) : Promise(Never, Void) {
    next
      {
        slug = Maybe.just(article.slug),
        tags = Set.fromArray(article.tags),
        extract = Maybe.withDefault("", article.description),
        content = article.body,
        title = article.title
      }
  }

  fun setExtract (value : String) : Promise(Never, Void) {
    next { extract = value }
  }

  fun setContent (value : String) : Promise(Never, Void) {
    next { content = value }
  }

  fun setTitle (value : String) : Promise(Never, Void) {
    next { title = value }
  }

  fun setTags (value : Set(String)) : Promise(Never, Void) {
    next { tags = value }
  }

  fun submit : Promise(Never, Void) {
    sequence {
      next { status = Api.Status::Loading }

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

      request =
        if (Maybe.isJust(slug)) {
          Http.put("/articles/" + Maybe.withDefault("", slug))
        } else {
          Http.post("/articles")
        }

      status =
        request
        |> Http.jsonBody(body)
        |> Api.send(Article.fromResponse)

      next { status = status }

      case (status) {
        Api.Status::Ok article =>
          sequence {
            Window.navigate("/article/" + article.slug)
          }

        => Promise.never()
      }
    }
  }
}

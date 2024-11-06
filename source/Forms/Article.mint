store Forms.Article {
  state status : Api.Status(Article) = Api.Status.Initial

  state slug : Maybe(String) = Maybe.nothing()
  state tags : Set(String) = Set.empty()
  state extract : String = ""
  state content : String = ""
  state title : String = ""

  fun reset : Promise(Void) {
    next {
      slug: Maybe.nothing(),
      tags: Set.empty(),
      extract: "",
      content: "",
      title: ""
    }
  }

  fun set (article : Article) : Promise(Void) {
    next {
      extract: Maybe.withDefault(article.description, ""),
      tags: Set.fromArray(article.tags),
      slug: Maybe.just(article.slug),
      content: article.body,
      title: article.title
    }
  }

  fun setTags (value : Set(String)) : Promise(Void) {
    next { tags: value }
  }

  fun setExtract (value : String) : Promise(Void) {
    next { extract: value }
  }

  fun setContent (value : String) : Promise(Void) {
    next { content: value }
  }

  fun setTitle (value : String) : Promise(Void) {
    next { title: value }
  }

  fun submit : Promise(Void) {
    await next { status: Api.Status.Loading }

    let body =
      encode {
        article:
          {
            tagList: Set.toArray(tags),
            description: extract,
            title: title,
            body: content
          }
      }

    let request =
      if Maybe.isJust(slug) {
        Http.put("/articles/" + (slug or ""))
      } else {
        Http.post("/articles")
      }

    let newStatus =
      await (request
      |> Http.jsonBody(body)
      |> Api.send(Article.fromResponse))

    if let Api.Status.Ok(article) = newStatus {
      Window.navigate("/article/" + article.slug)
    }

    next { status: newStatus }
  }
}

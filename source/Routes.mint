routes {
  /?page=:page (page : String) {
    Application.initializeWithPage(Page.Home)
    Stores.Articles.load("", page, "", false, false)
    Stores.Tags.load()
  }

  / {
    Application.initializeWithPage(Page.Home)
    Stores.Articles.load("", "", "", false, false)
    Stores.Tags.load()
  }

  /feed?tag=:tag&page=:page (tag : String, page : String) {
    Application.initializeWithPage(Page.Home)
    Stores.Articles.load("", page, tag, true, false)
    Stores.Tags.load()
  }

  /feed?page=:page (page : String) {
    Application.initializeWithPage(Page.Home)
    Stores.Articles.load("", page, "", true, false)
    Stores.Tags.load()
  }

  /articles?tag=:tag&page=:page (tag : String, page : String) {
    Application.initializeWithPage(Page.Home)
    Stores.Articles.load("", page, tag, false, false)
    Stores.Tags.load()
  }

  /articles?page=:page (page : String) {
    Application.initializeWithPage(Page.Home)
    Stores.Articles.load("", page, "", false, false)
    Stores.Tags.load()
  }

  /users/:username?page=:page (username : String, page : String) {
    Application.initializeWithPage(Page.Profile)
    Stores.Articles.load(username, page, "", false, false)
    Stores.Profile.load(username)
  }

  /users/:username (username : String) {
    Application.initializeWithPage(Page.Profile)
    Stores.Articles.load(username, "", "", false, false)
    Stores.Profile.load(username)
  }

  /users/:username/favorites?page=:page (username : String, page : String) {
    Application.initializeWithPage(Page.Profile)
    Stores.Articles.load(username, page, "", false, true)
    Stores.Profile.load(username)
  }

  /users/:username/favorites (username : String) {
    Application.initializeWithPage(Page.Profile)
    Stores.Articles.load(username, "", "", false, true)
    Stores.Profile.load(username)
  }

  /settings {
    await Application.initialize()

    await case Application.user {
      UserStatus.LoggedIn(user) =>
        {
          await Forms.Settings.set(user)
          await Application.setPage(Page.Settings)
        }

      UserStatus.LoggedOut => Window.navigate("/")
    }
  }

  /sign-in {
    await Application.initialize()

    await case Application.user {
      UserStatus.LoggedIn(user) => Window.navigate("/")

      UserStatus.LoggedOut =>
        {
          await Forms.SignIn.reset()
          await Application.setPage(Page.SignIn)
        }
    }
  }

  /sign-up {
    await Application.initialize()

    await case Application.user {
      UserStatus.LoggedOut => Application.setPage(Page.SignUp)
      UserStatus.LoggedIn(user) => Window.navigate("/")
    }
  }

  /new {
    await Application.initialize()
    await Forms.Article.reset()

    await case Application.user {
      UserStatus.LoggedIn(user) => Application.setPage(Page.Editor)
      UserStatus.LoggedOut => Window.navigate("/")
    }
  }

  /logout {
    await Application.initialize()

    await case Application.user {
      UserStatus.LoggedIn(user) => Application.logout()
      UserStatus.LoggedOut => Window.navigate("/")
    }
  }

  /article/:slug (slug : String) {
    Application.initializeWithPage(Page.Article)

    await {
      let article =
        case Stores.Articles.status {
          Api.Status.Ok(data) =>
            data.articles
            |> Array.find((article : Article) : Bool { article.slug == slug })
            |> Maybe.withDefault(Article.empty())

          => Article.empty()
        }

      if article.slug == slug {
        Stores.Article.set(article)
      } else {
        Stores.Article.load(slug)
      }
    }

    Window.setScrollTop(0)
    Stores.Comments.load(slug)
    Forms.Comment.reset()
  }

  /edit/:slug (slug : String) {
    await Application.initialize()

    await {
      let article =
        Stores.Article.article

      if article.slug == slug {
        Stores.Article.set(article)
      } else {
        Stores.Article.load(slug)
      }
    }

    case Stores.Article.status {
      Api.Status.Ok(article) =>
        {
          Forms.Article.set(article)
          Application.setPage(Page.Editor)
        }

      => Promise.never()
    }
  }

  * {
    Application.initializeWithPage(Page.NotFound)
  }
}

routes {
  / {
    let params =
      Window.url().search
      |> SearchParams.fromString()

    Application.initialize()

    let articles =
      await Api.loadArticles(0)

    Application.setPage(Page.Home(articles: articles, tags: []))

    // Stores.Articles.load("", page, "", false, false)
    Stores.Tags.load()
  }

  /*
  /feed?tag=:tag&page=:page (tag : String, page : String) {
    Application.initializeWithPage(Page.Home)

    // Stores.Articles.load("", page, tag, true, false)
    Stores.Tags.load()
  }

  /feed?page=:page (page : String) {
    Application.initializeWithPage(Page.Home)

    // Stores.Articles.load("", page, "", true, false)
    Stores.Tags.load()
  }

  /articles?tag=:tag&page=:page (tag : String, page : String) {
    Application.initializeWithPage(Page.Home)

    // Stores.Articles.load("", page, tag, false, false)
    Stores.Tags.load()
  }

  /articles?page=:page (page : String) {
    Application.initializeWithPage(Page.Home)

    // Stores.Articles.load("", page, "", false, false)
    Stores.Tags.load()
  }
  */
  /users/:username?page=:page (username : String, page : String) {
    Application.initializeWithPage(Page.Profile)

    // Stores.Articles.load(username, page, "", false, false)
    Stores.Profile.load(username)
  }

  /users/:username (username : String) {
    Application.initializeWithPage(Page.Profile)

    // Stores.Articles.load(username, "", "", false, false)
    Stores.Profile.load(username)
  }

  /users/:username/favorites?page=:page (username : String, page : String) {
    Application.initializeWithPage(Page.Profile)

    // Stores.Articles.load(username, page, "", false, true)
    Stores.Profile.load(username)
  }

  /users/:username/favorites (username : String) {
    Application.initializeWithPage(Page.Profile)

    // Stores.Articles.load(username, "", "", false, true)
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

    case Application.user {
      UserStatus.LoggedOut => Application.setPage(Page.SignIn)
      UserStatus.LoggedIn(user) => Window.navigate("/")
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

    await Stores.Article.load(slug)

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

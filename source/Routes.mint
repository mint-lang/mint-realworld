routes {
  /?page=:page (page : String) {
    parallel {
      Application.initializeWithPage(Page::Home)
      Stores.Articles.load("", page, "", false, false)
      Stores.Tags.load()
    }
  }

  / {
    parallel {
      Application.initializeWithPage(Page::Home)
      Stores.Articles.load("", "", "", false, false)
      Stores.Tags.load()
    }
  }

  /feed?tag=:tag&page=:page (tag : String, page : String) {
    parallel {
      Application.initializeWithPage(Page::Home)
      Stores.Articles.load("", page, tag, true, false)
      Stores.Tags.load()
    }
  }

  /feed?page=:page (page : String) {
    parallel {
      Application.initializeWithPage(Page::Home)
      Stores.Articles.load("", page, "", true, false)
      Stores.Tags.load()
    }
  }

  /articles?tag=:tag&page=:page (tag : String, page : String) {
    parallel {
      Application.initializeWithPage(Page::Home)
      Stores.Articles.load("", page, tag, false, false)
      Stores.Tags.load()
    }
  }

  /articles?page=:page (page : String) {
    parallel {
      Application.initializeWithPage(Page::Home)
      Stores.Articles.load("", page, "", false, false)
      Stores.Tags.load()
    }
  }

  /users/:username?page=:page (username : String, page : String) {
    parallel {
      Application.initializeWithPage(Page::Profile)
      Stores.Articles.load(username, page, "", false, false)
      Stores.Profile.load(username)
    }
  }

  /users/:username (username : String) {
    parallel {
      Application.initializeWithPage(Page::Profile)
      Stores.Articles.load(username, "", "", false, false)
      Stores.Profile.load(username)
    }
  }

  /users/:username/favorites?page=:page (username : String, page : String) {
    parallel {
      Application.initializeWithPage(Page::Profile)
      Stores.Articles.load(username, page, "", false, true)
      Stores.Profile.load(username)
    }
  }

  /users/:username/favorites (username : String) {
    parallel {
      Application.initializeWithPage(Page::Profile)
      Stores.Articles.load(username, "", "", false, true)
      Stores.Profile.load(username)
    }
  }

  /settings {
    sequence {
      Application.initialize()

      case (Application.user) {
        UserStatus::LoggedIn user =>
          sequence {
            Forms.Settings.set(user)
            Application.setPage(Page::Settings)
          }

        UserStatus::LoggedOut => Window.navigate("/")
      }
    }
  }

  /sign-in {
    sequence {
      Application.initialize()

      case (Application.user) {
        UserStatus::LoggedIn user => Window.navigate("/")

        UserStatus::LoggedOut =>
          parallel {
            Application.setPage(Page::SignIn)
            Forms.SignIn.reset()
          }
      }
    }
  }

  /sign-up {
    sequence {
      Application.initialize()

      case (Application.user) {
        UserStatus::LoggedOut => Application.setPage(Page::SignUp)
        UserStatus::LoggedIn user => Window.navigate("/")
      }
    }
  }

  /new {
    sequence {
      Application.initialize()
      Forms.Article.reset()

      case (Application.user) {
        UserStatus::LoggedIn user => Application.setPage(Page::Editor)
        UserStatus::LoggedOut => Window.navigate("/")
      }
    }
  }

  /logout {
    sequence {
      Application.initialize()

      case (Application.user) {
        UserStatus::LoggedIn user => Application.logout()
        UserStatus::LoggedOut => Window.navigate("/")
      }
    }
  }

  /article/:slug (slug : String) {
    parallel {
      Application.initializeWithPage(Page::Article)

      sequence {
        article =
          case (Stores.Articles.status) {
            Api.Status::Ok data =>
              data.articles
              |> Array.find(
                (article : Article) : Bool { article.slug == slug })
              |> Maybe.withDefault(Article.empty())

            => Article.empty()
          }

        if (article.slug == slug) {
          Stores.Article.set(article)
        } else {
          Stores.Article.load(slug)
        }
      }

      Window.setScrollTop(0)
      Stores.Comments.load(slug)
      Forms.Comment.reset()
    }
  }

  /edit/:slug (slug : String) {
    sequence {
      parallel {
        Application.initialize()

        sequence {
          article =
            Stores.Article.article

          if (article.slug == slug) {
            Stores.Article.set(article)
          } else {
            Stores.Article.load(slug)
          }
        }
      }

      case (Stores.Article.status) {
        Api.Status::Ok article =>
          parallel {
            Forms.Article.set(article)
            Application.setPage(Page::Editor)
          }

        => Promise.never()
      }
    }
  }

  * {
    Application.initializeWithPage(Page::NotFound)
  }
}

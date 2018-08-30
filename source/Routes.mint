routes {
  / {
    parallel {
      Application.initializeWithPage(Page::Home)
      Stores.Tags.load()

      sequence {
        params =
          Stores.Articles.params

        Stores.Articles.load({ params |
          author = "",
          tag = ""
        })
      }
    }
  }

  /articles?tag=:tag (tag : String) {
    parallel {
      Application.initializeWithPage(Page::Home)
      Stores.Tags.load()

      sequence {
        params =
          Stores.Articles.params

        Stores.Articles.load({ params |
          author = "",
          tag = tag
        })
      }
    }
  }

  /users/:username (username : String) {
    parallel {
      Application.initializeWithPage(Page::Profile)
      Stores.Profile.load(username)

      Stores.Articles.load(
        {
          tag = "",
          limit = 10,
          author = username
        })
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
      Stores.Comments.load(slug)
      Stores.Article.load(slug)
      Forms.Comment.reset()
    }
  }

  /edit/:slug (slug : String) {
    sequence {
      parallel {
        Application.initialize()
        Stores.Article.load(slug)
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

component Logo {
  property size : String = "24"

  style base {
    fill: currentColor;
  }

  fun render : Html {
    <svg::base
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      height={size}
      width={size}>

      <path
        d={
          "M16 0l-3 9h9l-1.866 2h-14.4l10.266-11zm2.267 13h-14.4l-1" \
          ".867 2h9l-3 9 10.267-11z"
        }/>

    </svg>
  }
}

component Main {
  connect Application exposing { page }

  fun render : Html {
    case (page) {
      Page::Home =>
        <Layout>
          <Pages.Home/>
        </Layout>

      Page::Article =>
        <Layout>
          <Pages.Article/>
        </Layout>

      Page::Editor =>
        <Layout>
          <Pages.Editor/>
        </Layout>

      Page::Profile =>
        <Layout>
          <Pages.Profile/>
        </Layout>

      Page::Settings =>
        <Layout>
          <Pages.Settings/>
        </Layout>

      Page::NotFound =>
        <Layout>
          <{ "WTF" }>
        </Layout>

      Page::Login => <Pages.Login/>
      Page::SignUp => <Pages.SignUp/>
      => Html.empty()
    }
  }
}

store Application {
  state page : Page = Page::Initial

  fun initializeWithPage (page : Page) : Promise(Never, Void) {
    sequence {
      setPage(page)
      initialize()
    }
  }

  fun initialize : Promise(Never, Void) {
    case (Stores.User.userStatus) {
      Api.Status::Initial => Stores.User.getCurrentUser()
      => Promise.never()
    }
  }

  fun setPage (page : Page) : Promise(Never, Void) {
    next { page = page }
  }
}

enum Page {
  Login
  Settings
  Profile
  SignUp
  Initial
  Home
  Editor
  Article
  NotFound
}

routes {
  / {
    parallel {
      Application.initializeWithPage(Page::Home)
      Stores.Tags.load()

      sequence {
        params =
          Stores.Articles.params

        Stores.Articles.load({ params |
          tag = "",
          author = ""
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
          tag = tag,
          author = ""
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

      case (Stores.User.userStatus) {
        Api.Status::Ok user =>
          sequence {
            Forms.Settings.set(user)
            Application.setPage(Page::Settings)
          }

        => Window.navigate("/")
      }
    }
  }

  /sign-in {
    sequence {
      Application.initialize()

      case (Stores.User.userStatus) {
        Api.Status::Ok user => Window.navigate("/")

        =>
          parallel {
            Application.setPage(Page::Login)
            Forms.Login.reset()
          }
      }
    }
  }

  /sign-up {
    sequence {
      Application.initialize()

      case (Stores.User.userStatus) {
        Api.Status::Ok user => Window.navigate("/")
        => Application.setPage(Page::SignUp)
      }
    }
  }

  /new {
    sequence {
      Application.initialize()
      Forms.Article.reset()

      case (Stores.User.userStatus) {
        Api.Status::Ok user => Application.setPage(Page::Editor)
        => Window.navigate("/")
      }
    }
  }

  /logout {
    sequence {
      Application.initialize()

      case (Stores.User.userStatus) {
        Api.Status::Ok user =>
          sequence {
            Stores.User.logout()
            Window.navigate("/")
          }

        =>
          sequence {
            Window.navigate("/")
          }
      }
    }
  }

  /article/:slug (slug : String) {
    parallel {
      Application.initializeWithPage(Page::Article)
      Stores.Article.load(slug)
      Stores.Comments.load(slug)
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

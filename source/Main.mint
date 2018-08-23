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

      Page::NotFound =>
        <Layout>
          <{ "WTF" }>
        </Layout>

      Page::Login => <Pages.Login/>
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
  Initial
  Home
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

        Stores.Articles.load({ params | tag = "" })
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

        Stores.Articles.load({ params | tag = tag })
      }
    }
  }

  /sign-in {
    sequence {
      Application.initialize()

      case (Stores.User.userStatus) {
        Api.Status::Ok user => Window.navigate("/")
        => Application.setPage(Page::Login)
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

  * {
    Application.initializeWithPage(Page::NotFound)
  }
}

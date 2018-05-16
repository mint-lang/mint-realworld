component Main {
  connect Application exposing { page }

  style layout {
    flex-direction: column;
    min-height: 100vh;
    display: flex;
  }

  style content {
    flex: 1;
  }

  get content : Html {
    case (page) {
      Page::Home => <Pages.Home/>
      Page::Article => <Pages.Article/>
      Page::Login => <Pages.Login/>
    }
  }

  fun render : Html {
    <div::layout>
      <Header/>

      <div::content>
        <{ content }>
      </div>

      <Footer/>
    </div>
  }
}

store Application {
  property page : Page = Page::Initial

  fun initializeWithPage (page : Page) : Void {
    do {
      initialize()
      setPage(page)
    }
  }

  fun initialize : Void {
    case (Stores.User.status) {
      Auth.Status::Initial => Stores.User.getCurrentUser()
      => void
    }
  }

  fun setPage (page : Page) : Void {
    next { state | page = page }
  }
}

enum Page {
  Login,
  Initial,
  Home,
  Article
}

routes {
  / {
    do {
      Application.initializeWithPage(Page::Home)

      params =
        Stores.Articles.params

      Array.do(
        [
          Stores.Articles.load({ params | tag = "" }),
          Stores.Tags.load()
        ])
    }
  }

  /articles?tag=:tag (tag : String) {
    do {
      Application.initializeWithPage(Page::Home)

      params =
        Stores.Articles.params

      Array.do(
        [
          Stores.Articles.load({ params | tag = tag }),
          Stores.Tags.load()
        ])
    }
  }

  /login {
    do {
      Application.initialize()

      case (Stores.User.status) {
        Auth.Status::Authenticated => Window.navigate("/")
        => Application.setPage(Page::Login)
      }
    }
  }

  /logout {
    do {
      Application.initialize()

      case (Stores.User.status) {
        Auth.Status::Authenticated =>
          do {
            Stores.User.logout()
            Window.navigate("/")
          }

        => Window.navigate("/")
      }
    }
  }

  /article/:slug (slug : String) {
    do {
      Application.initializeWithPage(Page::Article)

      Array.do(
        [
          Stores.Article.load(slug),
          do {
            Stores.Comments.reset()
            Stores.Comments.load(slug)
          }
        ])
    }
  }
}

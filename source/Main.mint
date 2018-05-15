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

  fun setPage (page : Page) : Void {
    case (Stores.User.status) {
      Auth.Status::Initial =>
        do {
          Stores.User.getCurrentUser()

          next { state | page = page }
        }

      => next { state | page = page }
    }
  }
}

enum Auth.Status {
  Unauthenticated,
  Authenticated,
  Initial
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
      Application.setPage(Page::Home)

      params =
        Stores.Articles.params

      Array.do(
        [
          Stores.Articles.load({ params | tag = Maybe.nothing() }),
          Stores.Tags.load()
        ])
    }
  }

  /articles?tag=:tag (tag : String) {
    do {
      Application.setPage(Page::Home)

      params =
        Stores.Articles.params

      Array.do(
        [
          Stores.Articles.load({ params | tag = Maybe.just(tag) }),
          Stores.Tags.load()
        ])
    }
  }

  /login {
    case (Stores.User.status) {
      Auth.Status::Authenticated => Window.navigate("/")
      => Application.setPage(Page::Login)
    }
  }

  /logout {
    case (Stores.User.status) {
      Auth.Status::Authenticated =>
        do {
          Stores.User.logout()

          Stores.Articles.reset()
          Stores.Article.reset()

          Window.navigate("/")
        }

      => Window.navigate("/")
    }
  }

  /article/:slug (slug : String) {
    do {
      Application.setPage(Page::Article)

      Stores.Article.load(slug)
    }
  }
}

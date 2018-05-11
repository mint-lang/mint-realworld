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
    next { state | page = page }
  }
}

enum Page {
  Initial,
  Home,
  Article
}

routes {
  / {
    do {
      Application.setPage(Page::Home)

      Array.do(
        [
          Stores.Articles.load(Maybe.nothing()),
          Stores.Tags.load()
        ])
    }
  }

  /articles?tag=:tag (tag : String) {
    do {
      Application.setPage(Page::Home)

      Array.do(
        [
          Stores.Articles.load(Maybe.just(tag)),
          Stores.Tags.load()
        ])
    }
  }

  /article/:slug (slug : String) {
    do {
      Application.setPage(Page::Article)
      Stores.Article.load(slug)
    }
  }
}

component Pages.Article {
  connect Stores.Article exposing { article, loading }

  style base {

  }

  style title {
    background: #333;
    height: 150px;
    color: white;
  }

  fun render : Html {
    <Loader loading={loading}>
      <div::base>
        <div::title>
          <h1>
            <{ article.title }>
          </h1>
        </div>

        <div>
          <{ article.body }>
        </div>
      </div>
    </Loader>
  }
}

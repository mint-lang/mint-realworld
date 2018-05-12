component Pages.Article {
  connect Stores.Article exposing { article, status }

  style base {

  }

  style title {
    background: #333;
    height: 150px;
    color: white;
  }

  fun render : Html {
    <Status status={status}>
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
    </Status>
  }
}

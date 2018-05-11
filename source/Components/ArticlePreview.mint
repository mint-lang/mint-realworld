component ArticlePreview {
  property article : Article = Article.empty()

  style base {
    display: grid;
  }

  fun render : Html {
    <div::base>
      <div class="article-meta">
        <a href="">
          <img src={article.author.image}/>
        </a>

        <div class="info">
          <a
            href=""
            class="author">

            <{ article.author.username }>

          </a>

          <span class="date">
            <{ Time.relative(article.createdAt, Time.now()) }>
          </span>
        </div>

        <button class="btn btn-outline-primary btn-sm pull-xs-right">
          <i class="ion-heart"/>
          <{ Number.toString(article.favoritesCount) }>
        </button>
      </div>

      <a
        href=""
        class="preview-link">

        <h1>
          <{ article.title }>
        </h1>

        <p>
          <{ article.description }>
        </p>

        <span>
          <{ "Read more..." }>
        </span>

      </a>
    </div>
  }
}

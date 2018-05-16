component Article.Preview {
  connect Theme exposing { link }

  property article : Article = Article.empty()

  style base {

  }

  style header {
    justify-content: space-between;
    margin-bottom: 10px;
    margin-bottom: 0;
    display: flex;
  }

  style button {

  }

  style title {
    margin-bottom: 5px;
    font-weight: bold;
    font-size: 20px;
  }

  style description {
    margin-bottom: 10px;
    font-size: 14px;
    opacity: 0.6;
  }

  style content {
    grid-area: content;

    & > a {
      text-decoration: none;
      transition: 150ms;
      color: inherit;
    }

    &:hover > a {
      color: {link};
    }
  }

  style link-text {
    font-size: 12px;
    opacity: 0.5;
  }

  get href : String {
    "/article/" + article.slug
  }

  fun render : Html {
    <div::base>
      <div::header>
        <Article.Profile article={article}/>

        <button::button>
          <i class="ion-heart"/>
          <{ Number.toString(article.favoritesCount) }>
        </button>
      </div>

      <div::content>
        <Link href={href}>
          <div::title>
            <{ article.title }>
          </div>

          <div::description>
            <{ article.description }>
          </div>

          <div::link-text>
            <{ "Read more..." }>
          </div>

          <TagList
            tags={article.tags}
            inactive={true}/>
        </Link>
      </div>
    </div>
  }
}

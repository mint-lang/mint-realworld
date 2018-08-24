component Article.Preview {
  connect Theme exposing { secondary, secondaryText }

  property article : Article = Article.empty()

  style base {
    border: 1px solid #EEE;
    border-radius: 2px;
  }

  style footer {
    justify-content: space-between;
    border-top: 1px solid #EEE;
    margin-bottom: 10px;
    background: #F6F6F6;
    margin-bottom: 0;
    display: flex;
    padding: 10px;
  }

  style button {
    background: #a7a7a7;
    color: {secondaryText};
    align-items: center;
    border-radius: 2px;
    display: flex;
    border: 0;

    &:hover {
      cursor: pointer;
    }
  }

  style button-text {
    margin-left: 5px;
    font-weight: 600;
  }

  style title {
    margin-bottom: 5px;
    font-weight: bold;
    font-size: 20px;
  }

  style description {
    margin-bottom: 10px;
    max-height: 200px;
    font-size: 14px;
    opacity: 0.6;
  }

  style content {
    grid-area: content;
  }

  style link {
    text-decoration: none;
    transition: 150ms;
    color: inherit;
    display: block;
    padding: 10px;
  }

  get href : String {
    "/article/" + article.slug
  }

  fun render : Html {
    <div::base>
      <div::content>
        <a::link href={href}>
          <div::title>
            <{ article.title }>
          </div>

          <div::description>
            <Markdown content={Maybe.withDefault("", article.description)}/>
          </div>

          <TagList
            tags={article.tags}
            inactive={true}/>
        </a>
      </div>

      <div::footer>
        <Article.Profile article={article}/>

        <button::button>
          <HeartIcon/>

          <span::button-text>
            <{ Number.toString(article.favoritesCount) }>
          </span>
        </button>
      </div>
    </div>
  }
}

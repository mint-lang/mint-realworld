component Articles.Item {
  connect Actions exposing { toggleFavorite }
  connect Theme exposing { primary }

  property article : Article = Article.empty()

  state loading : Bool = false

  style base {
    box-shadow: 0px 1px 3px 0px rgba(0,0,0,0.1);
    border-radius: 2px;
    background: #FFF;
    padding: 10px;
  }

  style footer {
    justify-content: space-between;
    border-top: 1px solid #EEE;
    margin-bottom: 10px;
    padding-top: 10px;
    margin-bottom: 0;
    display: flex;
  }

  style button {
    background: transparent;
    align-items: center;
    border-radius: 2px;
    display: flex;
    border: 0;

    if article.favorited {
      color: #e84848;
    } else {
      color: inherit;
    }

    &:hover {
      cursor: pointer;
    }

    &:disabled {
      opacity: 0.5;
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
    transition: 50ms;
    color: inherit;
    display: block;

    &:hover {
      color: #{primary};
    }
  }

  get href : String {
    "/article/" + article.slug
  }

  fun toggle (event : Html.Event) : Promise(Void) {
    await next { loading: true }
    await toggleFavorite(article)
    await next { loading: false }
  }

  fun render : Html {
    <div::base>
      <div::content>
        <a::link href={href}>
          <div::title>
            article.title
          </div>

          <div::description>
            <Markdown content={Maybe.withDefault(article.description, "")}/>
          </div>

          <TagList
            tags={article.tags}
            inactive={true}/>
        </a>
      </div>

      <div::footer>
        <Article.Info
          time={article.createdAt}
          author={article.author}/>

        <button::button
          onClick={toggle}
          disabled={loading}>

          <HeartIcon/>

          <span::button-text>
            Number.toString(article.favoritesCount)
          </span>

        </button>
      </div>
    </div>
  }
}

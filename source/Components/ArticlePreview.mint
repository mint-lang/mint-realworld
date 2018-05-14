component ArticlePreview {
  connect Theme exposing { link }

  property article : Article = Article.empty()

  style base {
    grid-template-columns: 40px 1fr 40px;
    grid-gap: 5px 10px;

    grid-template-areas: "profile info button"
                         "profile info button"
                         "content content content";

    display: grid;
  }

  style profile {
    grid-area: profile;

    & img {
      border-radius: 3px;
      height: 40px;
      width: 40px;
    }
  }

  style author {
    text-decoration: none;
    grid-area: author;
    font-size: 14px;
    display: block;
    color: {link};
  }

  style date {
    grid-area: date;
    font-size: 12px;
    opacity: 0.5;
  }

  style button {
    grid-area: button;
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

  style info {
    grid-area: info;
  }

  style link-text {
    font-size: 12px;
    opacity: 0.5;
  }

  style tag {
    & > * {
      margin-right: 5px;
      margin-top: 5px;
      opacity: 0.5;
    }
  }

  get href : String {
    "/article/" + article.slug
  }

  get tags : Array(Html) {
    article.tags
    |> Array.map(
      \tag : String =>
        <Tag
          inactive={true}
          name={tag}/>)
  }

  fun render : Html {
    <div::base>
      <a::profile href="">
        <img src={article.author.image}/>
      </a>

      <div::info>
        <a::author href="">
          <{ article.author.username }>
        </a>

        <span::date>
          <{ Time.relative(article.createdAt, Time.now()) }>
        </span>
      </div>

      <button::button>
        <i class="ion-heart"/>
        <{ Number.toString(article.favoritesCount) }>
      </button>

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

          <div::tag>
            <{ tags }>
          </div>
        </Link>
      </div>
    </div>
  }
}

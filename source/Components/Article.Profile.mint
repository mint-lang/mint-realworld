component Article.Profile {
  connect Theme exposing { link }

  property article : Article = Article.empty()

  style base {
    grid-template-areas: "image author"
                         "image date";

    grid-template-columns: 32px 1fr;
    grid-template-rows: 22px 10px;
    grid-gap: 0 10px;
    display: grid;
  }

  style profile {
    grid-area: image;
  }

  style author {
    text-transform: uppercase;
    text-decoration: none;
    grid-area: author;
    font-weight: 600;
    font-size: 14px;
    display: block;
    color: {link};
  }

  style date {
    line-height: 10px;
    grid-area: date;
    font-size: 10px;
    opacity: 0.5;
  }

  fun render : Html {
    <div::base>
      <a::profile href={profileUrl}>
        <Image
          src={article.author.image}
          key={article.slug}
          borderRadius="3px"
          height="32px"
          width="32px"/>
      </a>

      <a::author href={profileUrl}>
        <{ article.author.username }>
      </a>

      <span::date>
        <{ Time.relative(article.createdAt, Time.now()) }>
      </span>
    </div>
  } where {
    profileUrl =
      "/users/" + article.author.username
  }
}

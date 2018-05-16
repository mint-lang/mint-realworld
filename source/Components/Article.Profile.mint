component Article.Profile {
  connect Theme exposing { link }

  property article : Article = Article.empty()

  style base {
    grid-template-areas: "image author"
                         "image date";

    grid-template-columns: 32px 1fr;
    grid-template-rows: 16px 16px;
    grid-gap: 0 10px;
    display: grid;
  }

  style profile {
    grid-area: image;
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

  fun render : Html {
    <div::base>
      <a::profile href="">
        <Image
          src={article.author.image}
          borderRadius="16px"
          key={article.slug}
          height="32px"
          width="32px"/>
      </a>

      <a::author href="">
        <{ article.author.username }>
      </a>

      <span::date>
        <{ Time.relative(article.createdAt, Time.now()) }>
      </span>
    </div>
  }
}

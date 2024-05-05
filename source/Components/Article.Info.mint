component Article.Info {
  connect Theme exposing { primaryDark }

  property author : Author = Author.empty()
  property time : Time = Time.now()

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
    color: #{primaryDark};
    grid-area: author;
    font-weight: 600;
    font-size: 14px;
    display: block;
  }

  style date {
    line-height: 10px;
    grid-area: date;
    font-size: 10px;
    opacity: 0.5;
  }

  fun render : Html {
    <div::base>
      <a::profile href="/users/#{author.username}">
        <Image
          src={author.image}
          borderRadius="3px"
          height="32px"
          width="32px"/>
      </a>

      <a::author href="/users/#{author.username}">
        author.username
      </a>

      <span::date>
        Time.distanceOfTimeInWords(time, Time.now(), Time.Format.ENGLISH)
      </span>
    </div>
  }
}

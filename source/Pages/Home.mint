component Pages.Home {
  connect Stores.Articles exposing { articles, loading }
  connect Theme exposing { primary, primaryText }

  get articlePreviews : Array(Html) {
    articles
    |> Array.map(
      \article : Article => <ArticlePreview article={article}/>)
    |> Array.intersperse(<div::divider/>)
  }

  style base {

  }

  style divider {
    border-top: 1px solid #DDD;
    margin: 30px 0;
  }

  style banner {
    justify-content: center;
    flex-direction: column;
    background: {primary};
    color: {primaryText};
    align-items: center;
    text-align: center;
    display: flex;
    height: 170px;
  }

  style previews {
    margin-top: 50px;
  }

  style layout {
    grid-template-columns: 1fr 200px;
    max-width: 960px;
    margin: 0 auto;
    display: grid;
  }

  style tags {

  }

  fun render : Html {
    <div::base>
      <div::banner>
        <h1>
          <{ "Conduit" }>
        </h1>

        <p>
          <{ "A place to share your knowledge." }>
        </p>
      </div>

      <div::layout>
        <div::previews>
          <Loader loading={loading}>
            <{ articlePreviews }>
          </Loader>
        </div>

        <div::tags/>
      </div>
    </div>
  }
}

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

  style layout {
    grid-template-columns: 1fr 300px;
    max-width: 960px;
    display: grid;

    margin: 0 auto;
    margin-top: 30px;
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
        <div>
          <Loader
            loading={loading}
            overlay={Bool.not(Array.isEmpty(articlePreviews))}>

            <{ articlePreviews }>

          </Loader>
        </div>

        <PopularTags/>
      </div>
    </div>
  }
}

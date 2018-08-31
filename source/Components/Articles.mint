component Pagination.Page {
  connect Theme exposing { primary }

  property active : Bool = false
  property href : String = ""
  property page : String = ""

  style base {
    box-shadow: 0px 1px 3px 0px rgba(0,0,0,0.1);
    background: {background};
    text-decoration: none;
    border-radius: 2px;
    font-weight: bold;
    font-size: 14px;
    color: {color};

    justify-content: center;
    display: inline-flex;
    align-items: center;
    height: 40px;
    width: 40px;
  }

  get background : String {
    if (active) {
      primary
    } else {
      "white"
    }
  }

  get color : String {
    if (active) {
      "white"
    } else {
      "inherit"
    }
  }

  fun render : Html {
    <a::base href={href}>
      <{ page }>
    </a>
  }
}

component Articles {
  connect Stores.Articles exposing { params, status }

  get articles : Array(Html) {
    data.articles
    |> Array.map(
      (article : Article) : Html => { <Article.Preview article={article}/> })
    |> Array.intersperse(<div::divider/>)
  }

  style divider {
    margin: 20px 0;
  }

  style pagination {
    text-align: center;
    margin-top: 30px;

    & * + * {
      margin-left: 10px;
    }
  }

  get data : Stores.Articles {
    Api.withDefault({
      count = 0,
      articles = []
    }, status)
  }

  get pagination : Array(Html) {
    try {
      start =
        Math.max(1, params.page - 3)

      end =
        Math.min(
          Math.ceil(data.count / params.limit),
          params.page + 5)

      if (end > 1) {
        try {
          url =
            Window.url()

          searchParams =
            SearchParams.fromString(url.search)

          Array.range(start, end)
          |> Array.map(
            (page : Number) : Html => {
              try {
                pageString =
                  Number.toString(page)

                newSearchParams =
                  SearchParams.set("page", pageString, searchParams)

                href =
                  url.path + "?" + SearchParams.toString(newSearchParams)

                <Pagination.Page
                  active={page - 1 == params.page}
                  page={pageString}
                  href={href}/>
              }
            })
        }
      } else {
        []
      }
    }
  }

  fun render : Html {
    <Status
      message="There was an error loading the articles."
      loadingMessage="Loading articles..."
      status={status}>

      <{ articles }>

      <div::pagination>
        <{ pagination }>
      </div>

    </Status>
  }
}

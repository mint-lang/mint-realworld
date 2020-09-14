component Articles {
  connect Stores.Articles exposing { params, status }

  get articles : Array(Html) {
    for (article of data.articles) {
      <Articles.Item article={article}/>
    }
    |> Array.intersperse(<div::divider/>)
  }

  style divider {
    margin: 20px 0;
  }

  style pagination {
    grid-template-columns: repeat(auto-fill, minmax(40px, 1fr) );
    text-align: center;
    margin-top: 30px;
    grid-gap: 10px;
    display: grid;
  }

  get data : Stores.Articles {
    Api.withDefault(
      {
        count = 0,
        articles = []
      },
      status)
  }

  get pagination : Html {
    if (Array.isEmpty(pages)) {
      Html.empty()
    } else {
      <div::pagination>
        <{ pages }>
      </div>
    }
  } where {
    pages =
      getPages()
  }

  fun getPages : Array(Html) {
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
            (page : Number) : Html {
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
      status={Api.toStatus(status)}>

      <{ articles }>
      <{ pagination }>

    </Status>
  }
}

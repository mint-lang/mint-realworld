component Articles {
  connect Stores.Articles exposing { params, status }

  get articles : Array(Html) {
    for article of data.articles {
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
        count: 0,
        articles: []
      },
      status)
  }

  get pagination : Html {
    let pages =
      getPages()

    if Array.isEmpty(pages) {
      Html.empty()
    } else {
      <div::pagination>
        <{ pages }>
      </div>
    }
  }

  fun getPages : Array(Html) {
    let start =
      Math.max(1, params.page - 3)

    let end =
      Math.min(
        Math.ceil(data.count / params.limit),
        params.page + 5)

    if end > 1 {
      let url =
        Window.url()

      let searchParams =
        SearchParams.fromString(url.search)

      for page of Array.range(start, end) {
        let pageString =
          Number.toString(page)

        let newSearchParams =
          SearchParams.set(searchParams, "page", pageString)

        let href =
          url.path + "?" + SearchParams.toString(newSearchParams)

        <Pagination.Page
          active={page - 1 == params.page}
          page={pageString}
          href={href}/>
      }
    } else {
      []
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

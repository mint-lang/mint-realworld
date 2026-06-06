component Articles {
  property articles : Api.Status(Articles)

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

  fun render : Html {
    <Status
      message="There was an error loading the articles."
      loadingMessage="Loading articles..."
      status={Api.toStatus(articles)}
    >
      if let Ok(articles) = articles {
        <div>
          articles.items
          |> Array.map(
            (article : Article) { <Articles.Item article={article}/> })
          |> Array.intersperse(<div::divider/>)

          if articles.totalPages > 1 {
            let url =
              Window.url()

            let searchParams =
              SearchParams.fromString(url.search)

            <div::pagination>
              for page of Array.range(1, articles.totalPages) {
                let pageString =
                  Number.toString(page)

                let newSearchParams =
                  SearchParams.set(searchParams, "page", pageString)

                let href =
                  url.path + "?" + SearchParams.toString(newSearchParams)

                <Pagination.Page
                  active={page - 1 == articles.page}
                  page={pageString}
                  href={href}
                />
              }
            </div>
          }
        </div>
      }
    </Status>
  }
}

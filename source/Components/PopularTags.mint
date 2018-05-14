component PopularTags {
  connect Stores.Articles exposing { params }
  connect Stores.Tags exposing { tags, status }

  style tags {
    grid-template-columns: 1fr 1fr 1fr;
    grid-gap: 5px;
    display: grid;
  }

  style base {
    align-self: flex-start;
    background: #f3f3f3;
    border-radius: 3px;
    margin-left: 20px;
    padding: 10px;
  }

  style title {
    text-transform: uppercase;
    margin-bottom: 7px;
    font-weight: bold;
    font-size: 14px;
  }

  fun renderTag (tag : String) : Html {
    <Tag
      href={"/articles?tag=" + tag}
      active={active}
      name={tag}/>
  } where {
    active =
      (params.tag
      |> Maybe.withDefault("")) == tag
  }

  fun render : Html {
    <div::base>
      <div::title>
        <{ "Popular Tags" }>
      </div>

      <Status status={status}>
        <div::tags>
          <{ Array.map(renderTag, tags) }>
        </div>
      </Status>
    </div>
  }
}

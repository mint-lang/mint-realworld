component PopularTags {
  connect Stores.Articles exposing { params }
  connect Stores.Tags exposing { status }

  style tags {
    grid-template-columns: 1fr 1fr 1fr;
    grid-gap: 5px;
    display: grid;
  }

  style base {
    align-self: flex-start;
    border-radius: 3px;

    @media (max-width: 960px) {
      display: none;
    }
  }

  style title {
    text-transform: uppercase;
    margin-bottom: 7px;
    font-weight: bold;
    font-size: 14px;
  }

  fun renderTag (tag : String) : Html {
    <Tag
      active={active}
      name={tag}/>
  } where {
    active =
      params.tag == tag
  }

  fun render : Html {
    <div::base>
      <div::title>"Popular Tags"</div>

      <Status
        message="There was an error loading the popular tags."
        loadingMessage="Loading popular tags..."
        status={Api.toStatus(status)}>

        <div::tags>
          <{ Array.map(renderTag, tags) }>
        </div>

      </Status>
    </div>
  } where {
    tags =
      case (status) {
        Api.Status::Ok(tags) => tags
        => []
      }
  }
}

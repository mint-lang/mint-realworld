component PopularTags {
  connect Stores.Tags exposing { tags, loading }

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
    margin-bottom: 5px;
    font-weight: bold;
    font-size: 14px;
  }

  fun render : Html {
    <div::base>
      <div::title>
        <{ "Popular Tags" }>
      </div>

      <Loader
        loading={loading}
        overlay={Bool.not(Array.isEmpty(tags))}>

        <div::tags>
          <{
            Array.map(
              \tag : String =>
                <Tag
                  name={tag}
                  href={"/articles?tag=" + tag}/>,
              tags)
          }>
        </div>

      </Loader>
    </div>
  }
}

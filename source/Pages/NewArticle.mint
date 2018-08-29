component Pages.NewArticle {
  connect Stores.Article exposing { create, createStatus }

  state tags : Set(String) = Set.empty()
  state extract : String = ""
  state content : String = ""
  state title : String = ""

  style grid {
    grid-gap: 20px;
    display: grid;
    height: 70vh;

    grid-template-rows: min-content 1fr min-content;
    grid-template-columns: 1fr 1fr;

    grid-template-areas: "title content"
                         "extract content"
                         "tags content";

    & > *:nth-child(1) {
      grid-area: title;
    }

    & > *:nth-child(2) {
      grid-area: extract;
    }

    & > *:nth-child(3) {
      grid-area: tags;
    }

    & > *:last-child {
      grid-area: content;
    }
  }

  style cell {
    display: grid;
  }

  fun handleExtract (value : String) : Promise(Never, Void) {
    next { extract = value }
  }

  fun handleContent (value : String) : Promise(Never, Void) {
    next { content = value }
  }

  fun handleTitle (value : String) : Promise(Never, Void) {
    next { title = value }
  }

  fun handleTags (value : Set(String)) : Promise(Never, Void) {
    next { tags = value }
  }

  fun submit : Promise(Never, Void) {
    create(title, extract, content, tags)
  }

  get disabled : Bool {
    Api.isLoading(createStatus)
  }

  fun render : Html {
    <Layout.Form
      errors={Api.errorsOf("request", createStatus)}
      title="New Article"
      onSubmit={submit}>

      <div::grid>
        <div::cell>
          <Form.Field>
            <Input
              errors={Api.errorsOf("title", createStatus)}
              placeholder="Article Title..."
              onChange={handleTitle}
              disabled={disabled}
              value={title}
              name="Title"/>
          </Form.Field>
        </div>

        <div::cell>
          <Form.Field>
            <Textarea
              errors={Api.errorsOf("description", createStatus)}
              placeholder="Short description of the article..."
              onChange={handleExtract}
              disabled={disabled}
              value={extract}
              name="Extract"/>
          </Form.Field>
        </div>

        <div::cell>
          <Form.Field>
            <Label>
              <{ "Tags" }>
            </Label>

            <Tagger
              onChange={handleTags}
              disabled={disabled}
              placeholder="Tags"
              tags={tags}/>
          </Form.Field>
        </div>

        <div::cell>
          <Form.Field>
            <Textarea
              placeholder="The articles content in markdown..."
              errors={Api.errorsOf("body", createStatus)}
              onChange={handleContent}
              disabled={disabled}
              value={content}
              name="Content"/>
          </Form.Field>
        </div>
      </div>

    </Layout.Form>
  }
}

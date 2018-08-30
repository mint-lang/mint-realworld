component Pages.Editor {
  connect Forms.Article exposing {
    submit,
    status,
    slug,
    tags,
    extract,
    content,
    title,
    setExtract,
    setContent,
    setTitle,
    setTags
  }

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

  get disabled : Bool {
    Api.isLoading(status)
  }

  get formTitle : String {
    if (Maybe.isJust(slug)) {
      "Edit Article"
    } else {
      "New Article"
    }
  }

  get buttonText : String {
    if (disabled) {
      "Loading..."
    } else {
      if (Maybe.isJust(slug)) {
        "Update"
      } else {
        "Create"
      }
    }
  }

  get errors : Array(String) {
    Api.errorsOf("request", status)
    |> Array.concat(Api.errorsOf("article", status))
  }

  fun render : Html {
    <Layout.Form
      buttonText={buttonText}
      onSubmit={submit}
      title={formTitle}
      errors={errors}>

      <div::grid>
        <div::cell>
          <Form.Field>
            <Input
              errors={Api.errorsOf("title", status)}
              placeholder="Article Title..."
              onChange={setTitle}
              disabled={disabled}
              value={title}
              name="Title"/>
          </Form.Field>
        </div>

        <div::cell>
          <Form.Field>
            <Textarea
              placeholder="Short description of the article..."
              errors={Api.errorsOf("description", status)}
              onChange={setExtract}
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
              onChange={setTags}
              disabled={disabled}
              placeholder="Tags"
              tags={tags}/>
          </Form.Field>
        </div>

        <div::cell>
          <Form.Field>
            <Textarea
              placeholder="The articles content in markdown..."
              errors={Api.errorsOf("body", status)}
              onChange={setContent}
              disabled={disabled}
              value={content}
              name="Content"/>
          </Form.Field>
        </div>
      </div>

    </Layout.Form>
  }
}

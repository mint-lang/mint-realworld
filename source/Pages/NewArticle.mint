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

  style title {
    border-bottom: 1px solid #EEE;
    padding-bottom: 10px;
    margin-bottom: 20px;
    font-weight: bold;
    font-size: 22px;
  }

  style cell {
    display: grid;
  }

  style base {
    padding: 30px 0;
  }

  style hr {
    border: 0;
    border-top: 1px solid #EEE;
    margin: 20px 0;
  }

  style button {
    margin-left: auto;
    width: 150px;
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
    <div::base>
      <Container>
        <div::title>
          <{ "New Article" }>
        </div>

        <Form>
          <div::grid>
            <div::cell>
              <Form.Field>
                <Label>
                  <{ "Title" }>
                </Label>

                <Input
                  placeholder="Article Title..."
                  onChange={handleTitle}
                  disabled={disabled}
                  value={title}/>

                <Errors
                  errors={Api.errorsOf("title", createStatus)}
                  prefix="Title"/>
              </Form.Field>
            </div>

            <div::cell>
              <Form.Field>
                <Label>
                  <{ "Extract" }>
                </Label>

                <Textarea
                  placeholder="Short description of the article..."
                  onChange={handleExtract}
                  disabled={disabled}
                  value={extract}/>

                <Errors
                  errors={Api.errorsOf("description", createStatus)}
                  prefix="Extract"/>
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
                <Label>
                  <{ "Content" }>
                </Label>

                <Textarea
                  placeholder="The articles content in markdown..."
                  onChange={handleContent}
                  disabled={disabled}
                  value={content}/>

                <Errors
                  errors={Api.errorsOf("body", createStatus)}
                  prefix="Content"/>
              </Form.Field>
            </div>
          </div>
        </Form>

        <hr::hr/>

        <div::button>
          <Button
            disabled={disabled}
            onClick={(event : Html.Event) : Promise(Never, Void) => { submit() }}>

            <{ "Submit" }>

          </Button>
        </div>
      </Container>
    </div>
  }
}

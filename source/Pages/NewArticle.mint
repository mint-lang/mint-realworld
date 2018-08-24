component Pages.NewArticle {
  connect Stores.Article exposing { create, createStatus }
  state extract : String = ""
  state content : String = ""
  state title : String = ""
  state tag : String = ""

  style grid {
    grid-gap: 20px;
    display: grid;
    height: 70vh;

    grid-template-rows: min-content 1fr 1fr min-content;

    grid-template-areas: "title content"
                         "extract content"
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

  style base {

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

  fun handleTag (value : String) : Promise(Never, Void) {
    next { tag = value }
  }

  fun submit : Promise(Never, Void) {
    create(title, extract, content)
  }

  fun render : Html {
    <div::base>
      <Container>
        <{ "new Article" }>

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
                  value={title}/>
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
                  value={extract}/>
              </Form.Field>
            </div>

            <div::cell>
              <Form.Field>
                <Label>
                  <{ "Tags" }>
                </Label>

                <Input
                  placeholder="Tags"
                  onChange={handleTag}
                  value={tag}/>
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
                  value={content}/>
              </Form.Field>
            </div>
          </div>

          <button onClick={(event : Html.Event) : Promise(Never, Void) => { submit() }}>
            <{ "Submit" }>
          </button>
        </Form>
      </Container>
    </div>
  }
}

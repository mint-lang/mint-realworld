component Pages.NewArticle {
  connect Stores.Article exposing { create, createStatus }
  state extract : String = ""
  state content : String = ""
  state title : String = ""
  state tag : String = ""

  style row {
    display: flex;
  }

  style base {

  }

  style column {
    flex: 1;

    & + * {
      margin-left: 10px;
    }
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
          <div::row>
            <div::column>
              <Form.Field>
                <Label>
                  <{ "Title" }>
                </Label>

                <Input
                  placeholder="Article Title..."
                  onChange={handleTitle}
                  value={title}/>
              </Form.Field>

              <Form.Field>
                <Label>
                  <{ "Extract" }>
                </Label>

                <Textarea
                  placeholder="Short description of the article..."
                  onChange={handleExtract}
                  value={extract}
                  rows="20"/>
              </Form.Field>

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

            <div::column>
              <Form.Field>
                <Label>
                  <{ "Content" }>
                </Label>

                <Textarea
                  placeholder="The articles content in markdown..."
                  onChange={handleContent}
                  value={content}
                  rows="28"/>
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

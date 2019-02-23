component Markdown {
  property content : String = ""

  style base {
    & > *:first-child {
      margin-top: 0;
    }

    & > *:last-child {
      margin-bottom: 0;
    }
  }

  get html : String {
    `
    (() => {
      let reader = new commonmark.Parser()
      let writer = new commonmark.HtmlRenderer({ safe: true })
      let parsed = reader.parse(this.content)
      let result = writer.render(parsed)

      return result
    })()
    `
  }

  fun render : Html {
    <div::base dangerouslySetInnerHTML={`{__html: #{html}}`}/>
  }
}

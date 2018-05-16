component Markdown {
  property content : String = ""

  get html : String {
    `
    (() => {
      let reader = new commonmark.Parser()
      let writer = new commonmark.HtmlRenderer()
      let parsed = reader.parse(this.content)
      let result = writer.render(parsed)

      return result
    })()
    `
  }

  fun render : Html {
    <div dangerouslySetInnerHTML={`{__html: this.html}`}/>
  }
}

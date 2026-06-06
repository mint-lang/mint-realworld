type Article {
  description : Maybe(String),
  title : String,
  body : String,
  slug : String,
  created : Time,
  updated : Time,
  expand : ArticleExands,
  tags : Array(String)
}

type ArticleExands {
  author : Author
}

module Article {
  fun empty : Article {
    {
      body: "",
      created: Time.now(),
      description: Maybe.nothing(),
      slug: "",
      title: "",
      updated: Time.now(),
      expand: { author: Author.empty() },
      tags: []
    }
  }

  fun fromResponse (object : Object) : Result(Object.Error, Article) {
    Object.Decode.field(object, "article", decode as Article)
  }
}

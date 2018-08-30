record Article {
  description : Maybe(String),
  title : String,
  body : String,
  slug : String,
  favoritesCount : Number,
  favorited : Bool,
  createdAt : Time,
  updatedAt : Time,
  author : Author,
  tags : Array(String) using "tagList"
}

module Article {
  fun empty : Article {
    {
      body = "",
      createdAt = Time.now(),
      description = Maybe.nothing(),
      favorited = false,
      favoritesCount = 0,
      slug = "",
      title = "",
      updatedAt = Time.now(),
      author = Author.empty(),
      tags = []
    }
  }

  fun decode (object : Object) : Result(Object.Error, Article) {
    decode object as Article
  }

  fun fromResponse (object : Object) : Result(Object.Error, Article) {
    with Object.Decode {
      field("article", decode, object)
    }
  }
}

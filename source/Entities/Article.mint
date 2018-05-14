record Article {
  description : String,
  title : String,
  body : String,
  slug : String,
  favoritesCount : Number,
  favorited : Bool,
  createdAt : Time,
  updatedAt : Time,
  author : Author,
  tags : Array(String)
}

module Article {
  fun empty : Article {
    {
      body = "",
      createdAt = Time.now(),
      description = "",
      favorited = false,
      favoritesCount = 0,
      slug = "",
      title = "",
      updatedAt = Time.now(),
      author = Author.empty(),
      tags = []
    }
  }

  fun decodeMany (object : Object) : Result(Object.Error, Array(Article)) {
    Object.Decode.array(decode, object)
  }

  fun decode (object : Object) : Result(Object.Error, Article) {
    with Object.Decode {
      try {
        body =
          field("body", string, object)

        createdAt =
          field("createdAt", time, object)

        description =
          field("description", string, object)

        favorited =
          field("favorited", boolean, object)

        favoritesCount =
          field("favoritesCount", number, object)

        slug =
          field("slug", string, object)

        title =
          field("title", string, object)

        updatedAt =
          field("updatedAt", time, object)

        author =
          field("author", Author.decode, object)

        tags =
          field(
            "tagList",
            \input : Object => array(string, input),
            object)

        Result.ok(
          {
            body = body,
            author = author,
            createdAt = createdAt,
            description = description,
            favorited = favorited,
            favoritesCount = favoritesCount,
            slug = slug,
            title = title,
            updatedAt = updatedAt,
            tags = tags
          })
      } catch Object.Error => error {
        Result.error(error)
      }
    }
  }
}

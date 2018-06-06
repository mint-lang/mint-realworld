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
  tags : Array(String) from "tagList"
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
}

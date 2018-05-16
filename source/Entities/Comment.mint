record Comment {
  createdAt : Time,
  updatedAt : Time,
  author : Author,
  body : String,
  id : Number
}

module Comment {
  fun empty : Comment {
    {
      author = Author.empty(),
      createdAt = Time.now(),
      updatedAt = Time.now(),
      body = "",
      id = 0
    }
  }

  fun decodeComments (object : Object) : Result(Object.Error, Array(Comment)) {
    Object.Decode.field("comments", decodeMany, object)
  }

  fun decodeMany (object : Object) : Result(Object.Error, Array(Comment)) {
    Object.Decode.array(decode, object)
  }

  fun decode (object : Object) : Result(Object.Error, Comment) {
    with Object.Decode {
      try {
        author =
          field("author", Author.decode, object)

        body =
          field("body", string, object)

        id =
          field("id", number, object)

        createdAt =
          field("createdAt", time, object)

        updatedAt =
          field("updatedAt", time, object)

        Result.ok(
          {
            updatedAt = updatedAt,
            createdAt = createdAt,
            author = author,
            body = body,
            id = id
          })
      } catch Object.Error => error {
        Result.error(error)
      }
    }
  }
}

type Comment {
  createdAt : Time,
  updatedAt : Time,
  author : Author,
  body : String,
  id : Number
}

module Comment {
  fun empty : Comment {
    {
      author: Author.empty(),
      createdAt: Time.now(),
      updatedAt: Time.now(),
      body: "",
      id: 0
    }
  }

  fun fromResponse (object : Object) : Result(Object.Error, Comment) {
    Object.Decode.field(object, "comment", decode as Comment)
  }
}

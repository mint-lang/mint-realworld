record Author {
  bio : Maybe(String),
  username : String,
  following : Maybe(Bool),
  image : String
}

module Author {
  fun empty : Author {
    {
      bio: Maybe.nothing(),
      following: Maybe::Just(false),
      username: "",
      image: ""
    }
  }

  fun decodeEntity (object : Object) : Result(Object.Error, Author) {
    decode object as Author
  }

  fun fromResponse (object : Object) : Result(Object.Error, Author) {
    Object.Decode.field(object, "profile", decodeEntity)
  }
}

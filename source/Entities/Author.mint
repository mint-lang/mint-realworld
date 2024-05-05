type Author {
  bio : Maybe(String),
  username : String,
  following : Maybe(Bool),
  image : String
}

module Author {
  fun empty : Author {
    {
      bio: Maybe.nothing(),
      following: Maybe.Just(false),
      username: "",
      image: ""
    }
  }

  fun fromResponse (object : Object) : Result(Object.Error, Author) {
    Object.Decode.field(object, "profile", decode as Author)
  }
}

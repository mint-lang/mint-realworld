record Author {
  bio : Maybe(String),
  username : String,
  following : Bool,
  image : String
}

module Author {
  fun empty : Author {
    {
      bio = Maybe.nothing(),
      following = false,
      username = "",
      image = ""
    }
  }

  fun decode (object : Object) : Result(Object.Error, Author) {
    decode object as Author
  }

  fun fromResponse (object : Object) : Result(Object.Error, Author) {
    with Object.Decode {
      field("profile", decode, object)
    }
  }
}

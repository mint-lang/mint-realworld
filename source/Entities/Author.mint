record Author {
  bio : Maybe(String),
  following : Bool,
  image : String,
  username : String
}

module Author {
  fun empty : Author {
    {
      bio = Maybe.nothing(),
      following = false,
      image = "",
      username = ""
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

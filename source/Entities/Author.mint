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
}

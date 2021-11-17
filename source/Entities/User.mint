record User {
  bio : Maybe(String),
  email : String,
  image : Maybe(String),
  token : String,
  username : String
}

module User {
  fun empty : User {
    {
      bio = Maybe.nothing(),
      email = "",
      image = Maybe.nothing(),
      token = "",
      username = ""
    }
  }

  fun decode (object : Object) : Result(Object.Error, User) {
    decode object as User
  }

  fun fromResponse (object : Object) : Result(Object.Error, User) {
    with Object.Decode {
      field("user", decode, object)
    }
  }
}

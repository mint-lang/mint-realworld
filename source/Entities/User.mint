type User {
  bio : Maybe(String),
  email : String,
  image : Maybe(String),
  token : String,
  username : String
}

module User {
  fun empty : User {
    {
      bio: Maybe.nothing(),
      email: "",
      image: Maybe.nothing(),
      token: "",
      username: ""
    }
  }

  fun fromResponse (object : Object) : Result(Object.Error, User) {
    Object.Decode.field(object, "user", decode as User)
  }
}

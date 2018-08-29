record User {
  bio : Maybe(String),
  createdAt : Time,
  email : String,
  id : Number,
  image : Maybe(String),
  token : String,
  updatedAt : Time,
  username : String
}

module User {
  fun empty : User {
    {
      bio = Maybe.nothing(),
      createdAt = Time.now(),
      email = "",
      id = -1,
      image = Maybe.nothing(),
      token = "",
      updatedAt = Time.now(),
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

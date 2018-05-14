record User {
  bio : String,
  createdAt : Time,
  email : String,
  id : Number,
  image : String,
  token : String,
  updatedAt : Time,
  username : String
}

module User {
  fun decode (object : Object) : Result(Object.Error, User) {
    Object.Decode.field("user", decodeUser, object)
  }

  fun decodeUser (object : Object) : Result(Object.Error, User) {
    with Object.Decode {
      try {
        bio =
          field("bio", string, object)
          |> Result.withDefault("")

        image =
          field("image", string, object)
          |> Result.withDefault("")

        email =
          field("email", string, object)

        username =
          field("username", string, object)

        id =
          field("id", number, object)

        token =
          field("token", string, object)

        createdAt =
          field("createdAt", time, object)

        updatedAt =
          field("updatedAt", time, object)

        Result.ok(
          {
            bio = bio,
            createdAt = createdAt,
            email = email,
            id = id,
            image = image,
            token = token,
            updatedAt = updatedAt,
            username = username
          })
      } catch Object.Error => error {
        Result.error(error)
      }
    }
  }
}

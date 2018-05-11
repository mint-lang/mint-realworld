record Author {
  bio : String,
  following : Bool,
  image : String,
  username : String
}

module Author {
  fun empty : Author {
    {
      bio = "",
      following = false,
      image = "",
      username = ""
    }
  }

  fun decode (object : Object) : Result(Object.Error, Author) {
    with Object.Decode {
      try {
        bio =
          field("bio", string, object)
          |> Result.withDefault("")

        image =
          field("image", string, object)

        following =
          field("following", boolean, object)

        username =
          field("username", string, object)

        Result.ok(
          {
            bio = bio,
            image = image,
            following = following,
            username = username
          })
      } catch Object.Error => error {
        Result.error(error)
      }
    }
  }
}

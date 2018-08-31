store Stores.Profile {
  state status : Api.Status(Author) = Api.Status::Initial

  get profile : Author {
    Api.withDefault(Author.empty(), status)
  }

  fun setProfile (profile : Author) : Promise(Never, Void) {
    next { status = Api.Status::Ok(profile) }
  }

  fun load (author : String) : Promise(Never, Void) {
    if (profile.username != author) {
      sequence {
        next { status = Api.Status::Loading }

        newStatus =
          Http.get("/profiles/" + author)
          |> Api.send(Author.fromResponse)

        next { status = newStatus }
      }
    } else {
      Promise.never()
    }
  }
}

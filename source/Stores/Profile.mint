store Stores.Profile {
  state status : Api.Status(Author) = Api.Status.Initial

  get profile : Author {
    Api.withDefault(Author.empty(), status)
  }

  fun setProfile (profile : Author) : Promise(Void) {
    next { status: Api.Status.Ok(profile) }
  }

  fun load (author : String) : Promise(Void) {
    if profile.username != author {
      await next { status: Api.Status.Loading }

      let newStatus =
        await (Http.get("/profiles/" + author)
        |> Api.send(Author.fromResponse))

      await next { status: newStatus }
    } else {
      next { }
    }
  }
}

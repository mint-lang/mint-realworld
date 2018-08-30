store Stores.Profile {
  state status : Api.Status(Author) = Api.Status::Initial

  fun setProfile (profile : Author) : Promise(Never, Void) {
    next { status = Api.Status::Ok(profile) }
  }

  fun load (author : String) : Promise(Never, Void) {
    sequence {
      next { status = Api.Status::Loading }

      status =
        Http.get("/profiles/" + author)
        |> Api.send(Author.fromResponse)

      next { status = status }
    }
  }
}

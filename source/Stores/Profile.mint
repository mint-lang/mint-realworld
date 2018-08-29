store Stores.Profile {
  state status : Api.Status(Author) = Api.Status::Initial

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

store Stores.Comments {
  state status : Api.Status(Array(Comment)) = Api.Status.Initial

  fun reset : Promise(Void) {
    next { status: Api.Status.Initial }
  }

  fun load (slug : String) : Promise(Void) {
    await next { status: Api.Status.Loading }

    let newStatus =
      Http.get("/articles/" + slug + "/comments")
      |> Api.send(
        (object : Object) : Result(Object.Error, Array(Comment)) {
          Object.Decode.field(object, "comments", decode as Array(Comment))
        })

    next { status: await newStatus }
  }
}

store Stores.Comments {
  state status : Api.Status(Array(Comment)) = Api.Status::Initial

  fun reset : Promise(Void) {
    next { status: Api.Status::Initial }
  }

  fun load (slug : String) : Promise(Void) {
    await next { status: Api.Status::Loading }

    let newStatus =
      await Http.get("/articles/" + slug + "/comments")
      |> Api.send(
        (object : Object) : Result(Object.Error, Array(Comment)) {
          Object.Decode.field(
            object,
            "comments",
            (input : Object) : Result(Object.Error, Array(Comment)) { decode input as Array(Comment) })
        })

    await next { status: newStatus }
  }
}

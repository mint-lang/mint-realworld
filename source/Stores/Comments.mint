store Stores.Comments {
  state status : Api.Status(Array(Comment)) = Api.Status::Initial

  fun reset : Promise(Never, Void) {
    next { status = Api.Status::Initial }
  }

  fun load (slug : String) : Promise(Never, Void) {
    sequence {
      next { status = Api.Status::Loading }

      newStatus =
        Http.get("/articles/" + slug + "/comments")
        |> Api.send(
          (object : Object) : Result(Object.Error, Array(Comment)) {
            Object.Decode.field(
              "comments",
              (input : Object) : Result(Object.Error, Array(Comment)) { decode input as Array(Comment) },
              object)
          })

      next { status = newStatus }
    }
  }
}

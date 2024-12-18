store Forms.Comment {
  state status : Api.Status(Comment) = Api.Status.Initial

  state comment : String = ""

  fun reset : Promise(Void) {
    next { comment: "" }
  }

  fun setComment (value : String) : Promise(Void) {
    next { comment: value }
  }

  fun submit (slug : String) : Promise(Void) {
    await next { status: Api.Status.Loading }

    let params =
      encode { comment: { body: comment } }

    let newStatus =
      await (Http.post("/articles/" + slug + "/comments")
      |> Http.jsonBody(params)
      |> Api.send(Comment.fromResponse))

    next { status: newStatus }

    if let Api.Status.Ok(value) = newStatus {
      await Stores.Comments.load(slug)
      await reset()
    }
  }
}

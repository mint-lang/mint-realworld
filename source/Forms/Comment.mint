store Forms.Comment {
  state status : Api.Status(Comment) = Api.Status::Initial

  state comment : String = ""

  fun reset : Promise(Void) {
    next { comment: "" }
  }

  fun setComment (value : String) : Promise(Void) {
    next { comment: value }
  }

  fun submit (slug : String) : Promise(Void) {
    await next { status: Api.Status::Loading }

    let params =
      encode { comment: { body: comment } }

    let newStatus =
      await Http.post("/articles/" + slug + "/comments")
      |> Http.jsonBody(params)
      |> Api.send(Comment.fromResponse)

    await next { status: newStatus }

    await case (newStatus) {
      Api.Status::Ok =>
        {
          await Stores.Comments.load(slug)
          await reset()
        }

      => Promise.never()
    }
  }
}

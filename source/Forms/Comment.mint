store Forms.Comment {
  state status : Api.Status(Comment) = Api.Status::Initial

  state comment : String = ""

  fun reset : Promise(Never, Void) {
    next { comment = "" }
  }

  fun setComment (value : String) : Promise(Never, Void) {
    next { comment = value }
  }

  fun submit (slug : String) : Promise(Never, Void) {
    sequence {
      next { status = Api.Status::Loading }

      params =
        encode { comment = { body = comment } }

      newStatus =
        Http.post("/articles/" + slug + "/comments")
        |> Http.jsonBody(params)
        |> Api.send(Comment.fromResponse)

      next { status = newStatus }

      case (newStatus) {
        Api.Status::Ok =>
          parallel {
            Stores.Comments.load(slug)
            reset()
          }

        => Promise.never()
      }
    }
  }
}

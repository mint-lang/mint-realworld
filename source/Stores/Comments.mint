store Stores.Comments {
  state status : Api.Status(Array(Comment)) = Api.Status::Initial
  state slug : String = ""

  fun reset : Promise(Never, Void) {
    next { status = Api.Status::Initial }
  }

  fun load (newSlug : String) : Promise(Never, Void) {
    if (slug == newSlug && status != Api.Status::Initial) {
      Promise.never()
    } else {
      sequence {
        next { status = Api.nextStatus(status) }

        status =
          Api.endpoint() + "/articles/" + newSlug + "/comments"
          |> Http.get()
          |> Api.send(
            (object : Object) : Result(Object.Error, Array(Comment)) => {
              Object.Decode.field(
                "comments",
                (input : Object) : Result(Object.Error, Array(Comment)) => { decode input as Array(Comment) },
                object)
            })

        next
          {
            status = status,
            slug = newSlug
          }
      }
    }
  }
}

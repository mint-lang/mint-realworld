store Stores.Comments {
  state status : Api.Status = Api.Status::Initial
  state comments : Array(Comment) = []
  state slug : String = ""

  fun reset : Void {
    next
      {
        status = Api.Status::Initial,
        comments = []
      }
  }

  fun load (newSlug : String) : Void {
    if (slug == newSlug && status != Api.Status::Initial) {
      void
    } else {
      do {
        next { status = Api.nextStatus(status) }

        comments =
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
            status = Api.Status::Ok,
            comments = comments,
            slug = newSlug
          }
      } catch Api.Status => status {
        next { status = status }
      }
    }
  }
}

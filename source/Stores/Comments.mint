store Stores.Comments {
  property status : Api.Status = Api.Status::Initial
  property comments : Array(Comment) = []
  property slug : String = ""

  fun reset : Void {
    next
      { state |
        status = Api.Status::Initial,
        comments = []
      }
  }

  fun load (newSlug : String) : Void {
    if (slug == newSlug && status != Api.Status::Initial) {
      void
    } else {
      do {
        next { state | status = Api.nextStatus(status) }

        comments =
          Api.endpoint() + "/articles/" + newSlug + "/comments"
          |> Http.get()
          |> Api.send(
              \object : Object =>
                Object.Decode.field(
                  "comments",
                  \input : Object => decode input as Array(Comment),
                  object))

        next
          { state |
            status = Api.Status::Ok,
            comments = comments,
            slug = newSlug
          }
      } catch Api.Status => status {
        next { state | status = status }
      }
    }
  }
}

store Stores.Tags {
  state status : Api.Status = Api.Status::Initial
  state tags : Array(String) = []
  state cached : Bool = false

  fun decodeTags (object : Object) : Result(Object.Error, Array(String)) {
    with Object.Decode {
      field(
        "tags",
        (input : Object) : Result(Object.Error, Array(String)) => { decode input as Array(String) },
        object)
    }
  }

  fun load : Void {
    if (cached) {
      void
    } else {
      with Http {
        do {
          next { status = Api.nextStatus(status) }

          tags =
            Http.get(Api.endpoint() + "/tags")
            |> Api.send(decodeTags)

          next
            {
              status = Api.Status::Ok,
              cached = true,
              tags = tags
            }
        } catch Api.Status => status {
          next { status = status }
        }
      }
    }
  }
}

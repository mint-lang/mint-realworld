store Stores.Tags {
  property status : Api.Status = Api.Status::Initial
  property tags : Array(String) = []
  property cached : Bool = false

  fun decodeTags (object : Object) : Result(Object.Error, Array(String)) {
    with Object.Decode {
      field("tags", \input : Object => array(string, input), object)
    }
  }

  fun load : Void {
    if (cached) {
      void
    } else {
      with Http {
        do {
          next { state | status = Api.nextStatus(status) }

          tags =
            Api.endpoint() + "/tags"
            |> Http.get()
            |> Api.send(decodeTags)

          next
            { state |
              status = Api.Status::Ok,
              cached = true,
              tags = tags
            }
        } catch Api.Status => status {
          next { state | status = status }
        }
      }
    }
  }
}

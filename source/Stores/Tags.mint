store Stores.Tags {
  state status : Api.Status(Array(String)) = Api.Status::Initial
  state cached : Bool = false

  fun decodeTags (object : Object) : Result(Object.Error, Array(String)) {
    with Object.Decode {
      field(
        "tags",
        (input : Object) : Result(Object.Error, Array(String)) => { decode input as Array(String) },
        object)
    }
  }

  fun load : Promise(Never, Void) {
    if (cached) {
      Promise.never()
    } else {
      with Http {
        sequence {
          next { status = Api.Status::Loading }

          status =
            Http.get("/tags")
            |> Api.send(decodeTags)

          next
            {
              status = status,
              cached = true
            }
        }
      }
    }
  }
}

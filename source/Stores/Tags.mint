store Stores.Tags {
  state status : Api.Status(Array(String)) = Api.Status.Initial
  state cached : Bool = false

  fun decodeTags (object : Object) : Result(Object.Error, Array(String)) {
    Object.Decode.field(object, "tags", decode as Array(String))
  }

  fun load : Promise(Void) {
    if cached {
      Promise.never()
    } else {
      await next { status: Api.Status.Loading }

      let newStatus =
        Api.send(Http.get("/tags"), decodeTags)

      next { status: await newStatus, cached: true }
    }
  }
}

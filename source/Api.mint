enum Api.Status {
  Error,
  Loading,
  Reloading,
  Initial,
  Ok
}

module Api {
  fun then (updater : Function(Result(a, b), Result(c, d)), promise : Promise(a, b)) : Promise(c, d) {
    `
    promise
      .then((data) => updater(new Ok(data)))
      .catch((error) => { throw updater(new Err(error)).value })
    `
  }

  fun endpoint : String {
    "https://conduit.productionready.io/api"
  }

  fun nextStatus (status : Api.Status) : Api.Status {
    case (status) {
      Api.Status::Initial => Api.Status::Loading
      => Api.Status::Reloading
    }
  }

  fun send (decoder : Function(Object, Result(Object.Error, a)), request : Http.Request) : Promise(Api.Status, a) {
    request
    |> Http.send()
    |> then(
      \result : Result(Http.ErrorResponse, Http.Response) =>
        try {
          response =
            result

          object =
            Json.parse(response.body)
            |> Maybe.toResult("")

          data =
            decoder(object)

          Result.ok(data)
        } catch Http.ErrorResponse => error {
          Result.error(Api.Status::Error)
        } catch Object.Error => error {
          Result.error(Api.Status::Error)
        } catch String => error {
          Result.error(Api.Status::Error)
        })
  }
}

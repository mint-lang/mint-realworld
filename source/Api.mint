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
      .then((data) => {
        let result = updater(new Ok(data))

        if (result instanceof Err) {
          throw result.value
        } else {
          return result
        }
      })
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

  fun send (decoder : Function(Object, Result(Object.Error, a)), rawRequest : Http.Request) : Promise(Api.Status, a) {
    request
    |> Http.send()
    |> then(
      \result : Result(Http.ErrorResponse, Http.Response) =>
        try {
          response =
            result

          if (response.status == 401) {
            Result.error(Api.Status::Error)
          } else {
            try {
              object =
                Json.parse(response.body)
                |> Maybe.toResult("")

              data =
                decoder(object)

              Result.ok(data)
            } catch Object.Error => error {
              Result.error(error)
              |> Debug.log()
              |> Result.withDefault(Api.Status::Error)
              |> Result.error()
            } catch String => error {
              Result.error(Api.Status::Error)
            }
          }
        } catch Http.ErrorResponse => error {
          Result.error(Api.Status::Error)
        })
  } where {
    request =
      try {
        token =
          Storage.Session.get("token")

        rawRequest
        |> Http.header("Authorization", "Token " + token)
      } catch Storage.Error => error {
        rawRequest
      }
  }
}

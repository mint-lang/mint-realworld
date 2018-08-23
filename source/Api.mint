enum Api.Status(a) {
  Error
  Loading
  Initial
  Ok(a)
}

module Api {
  fun then (
    updater : Function(Result(a, b), c),
    promise : Promise(a, b)
  ) : Promise(Never, c) {
    `promise.then((data) => { return updater(new Ok(data)) })`
  }

  fun withDefault (a : a, status : Api.Status(a)) : a {
    case (status) {
      Api.Status::Ok value => value
      => a
    }
  }

  fun isLoading (status : Api.Status(a)) : Bool {
    case (status) {
      Api.Status::Loading => true
      => false
    }
  }

  fun endpoint : String {
    "https://conduit.productionready.io/api"
  }

  fun send (
    decoder : Function(Object, Result(Object.Error, a)),
    rawRequest : Http.Request
  ) : Promise(Never, Api.Status(a)) {
    sequence {
      response =
        request
        |> Http.header("Content-Type", "application/json")
        |> Http.send()

      if (response.status == 401) {
        Api.Status::Error
      } else {
        try {
          object =
            Json.parse(response.body)
            |> Maybe.toResult("")

          data =
            decoder(object)

          Api.Status::Ok(data)
        } catch Object.Error => error {
          Api.Status::Error
        } catch String => error {
          Api.Status::Error
        }
      }
    } catch Http.ErrorResponse => error {
      Api.Status::Error
    }
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

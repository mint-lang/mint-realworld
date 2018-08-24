enum Api.Status(a) {
  Error(Array(String))
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
    /* "https://conduit.productionready.io/api" */
    "http://localhost:3001/api"
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

      case (response.status) {
        401 => Api.Status::Error(["Unauthorized."])
        422 => Api.Status::Error(["Invalid data."])

        =>
          try {
            object =
              Json.parse(response.body)
              |> Maybe.toResult("")

            data =
              decoder(object)

            Api.Status::Ok(data)
          } catch Object.Error => error {
            Api.Status::Error(["Could not decode the response."])
          } catch String => error {
            Api.Status::Error(["Could not parse the response."])
          }
      }
    } catch Http.ErrorResponse => error {
      Api.Status::Error(["Network error."])
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

enum Api.Status(a) {
  Error(Array(String))
  Loading
  Initial
  Ok(a)
}

module Api {
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

  fun send (
    decoder : Function(Object, Result(Object.Error, a)),
    rawRequest : Http.Request
  ) : Promise(Never, Api.Status(a)) {
    sequence {
      /* We try to get a token from session storage. */
      request =
        try {
          token =
            Storage.Session.get("token")

          Http.header("Authorization", "Token " + token, rawRequest)
        } catch Storage.Error => error {
          rawRequest
        }

      /* "https://conduit.productionready.io/api" */

      /* Get the response. */
      response =
        { request | url = "https://conduit.productionready.io/api" + request.url }
        |> Http.header("Content-Type", "application/json")
        |> Http.send()

      /* Handle response based on status. */
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
  }
}

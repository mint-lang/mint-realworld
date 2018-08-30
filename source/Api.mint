enum Api.Status(a) {
  Error(Map(String, Array(String)))
  Loading
  Initial
  Ok(a)
}

record ErrorResponse {
  errors : Map(String, Array(String))
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

  fun errorStatus (key : String, value : String) : Api.Status(a) {
    Api.Status::Error(error)
  } where {
    error =
      Map.empty()
      |> Map.set(key, [value])
  }

  fun errorsOf (key : String, status : Api.Status(a)) : Array(String) {
    case (status) {
      Api.Status::Error errors =>
        errors
        |> Map.get(key)
        |> Maybe.withDefault([])

      => []
    }
  }

  fun decodeErrors (body : String) : Api.Status(a) {
    try {
      object =
        Json.parse(body)
        |> Maybe.toResult("")

      errors =
        decode object as ErrorResponse

      Api.Status::Error(errors.errors)
    } catch Object.Error => error {
      errorStatus("request", "Could not decode the error response.")
    } catch String => error {
      errorStatus("request", "Could not parse the error response.")
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

      /* Get the response. */
      response =
        { request | url = "https://conduit.productionready.io/api" + request.url }
        |> Http.header("Content-Type", "application/json")
        |> Http.send()

      /* Handle response based on status. */
      case (response.status) {
        401 => errorStatus("request", "Unauthorized!")
        403 => decodeErrors(response.body)
        422 => decodeErrors(response.body)

        =>
          try {
            object =
              Json.parse(response.body)
              |> Maybe.toResult("")

            data =
              decoder(object)

            Api.Status::Ok(data)
          } catch Object.Error => error {
            errorStatus("request", "Could not decode the response.")
          } catch String => error {
            errorStatus("request", "Could not parse the response.")
          }
      }
    } catch Http.ErrorResponse => error {
      errorStatus("request", "Network error.")
    }
  }
}

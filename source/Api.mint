/* Represents the status of an API Call. */
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
  fun toStatus (status : Api.Status(a)) : Status {
    case status {
      Api.Status::Loading => Status::Loading
      Api.Status::Initial => Status::Initial
      Api.Status::Error => Status::Error
      Api.Status::Ok => Status::Ok
    }
  }

  fun withDefault (a : a, status : Api.Status(a)) : a {
    case status {
      Api.Status::Ok(value) => value
      => a
    }
  }

  fun isLoading (status : Api.Status(a)) : Bool {
    case status {
      Api.Status::Loading => true
      => false
    }
  }

  fun errorStatus (key : String, value : String) : Api.Status(a) {
    let error =
      Map.empty()
      |> Map.set(key, [value])

    Api.Status::Error(error)
  }

  fun errorsOf (key : String, status : Api.Status(a)) : Array(String) {
    case status {
      Api.Status::Error(errors) =>
        errors
        |> Map.get(key)
        |> Maybe.withDefault([])

      => []
    }
  }

  fun decodeErrors (body : String) : Api.Status(a) {
    case Json.parse(body) {
      Result::Err => errorStatus("request", "Could not parse the error response.")

      Result::Ok(object) =>
        case decode object as ErrorResponse {
          Result::Ok(errors) => Api.Status::Error(errors.errors)
          Result::Err => errorStatus("request", "Could not decode the error response.")
        }
    }
  }

  fun send (
    rawRequest : Http.Request,
    decoder : Function(Object, Result(Object.Error, a))
  ) : Promise(Api.Status(a)) {
    /* We try to get a token from session storage. */
    let request =
      case Application.user {
        UserStatus::LoggedIn(user) =>
          Http.header(
            rawRequest,
            "Authorization",
            "Token " + user.token)

        UserStatus::LoggedOut => rawRequest
      }

    /* Get the response. */
    let result =
      await { request | url: "https://conduit.productionready.io/api" + request.url }
      |> Http.header("Content-Type", "application/json")
      |> Http.send()

    case result {
      Result::Err => errorStatus("request", "Network error.")

      Result::Ok(response) =>
        {
          /* Handle response based on status. */
          case response.status {
            401 => errorStatus("request", "Unauthorized!")
            403 => decodeErrors(response.bodyString)
            422 => decodeErrors(response.bodyString)

            =>
              case Json.parse(response.bodyString) {
                Result::Err => errorStatus("request", "Could not parse the response.")

                Result::Ok(object) =>
                  case decoder(object) {
                    Result::Ok(data) => Api.Status::Ok(data)
                    Result::Err => errorStatus("request", "Could not decode the response.")
                  }
              }
          }
        }
    }
  }
}

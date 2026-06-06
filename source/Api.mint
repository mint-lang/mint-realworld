type Api.Status(a) {
  Error(Map(String, ErrorData))
  Errored(String)
  Loading
  Initial
  Ok(a)
}

type ErrorResponse {
  data : Map(String, ErrorData),
  message : String
}

type ErrorData {
  message : String,
  code : String
}

type Articles {
  items : Array(Article),
  totalPages : Number,
  totalItems : Number,
  perPage : Number,
  page : Number
}

module Api {
  fun toStatus (status : Api.Status(a)) : Status {
    case status {
      Api.Status.Loading => Status.Loading
      Api.Status.Initial => Status.Initial
      Api.Status.Errored => Status.Error
      Api.Status.Error => Status.Error
      Api.Status.Ok => Status.Ok
    }
  }

  fun cast (status : Api.Status(a), decoder : Maybe(b)) : Api.Status(b) {
    `#{status}`
  }

  fun withDefault (a : a, status : Api.Status(a)) : a {
    case status {
      Api.Status.Ok(value) => value
      => a
    }
  }

  fun isLoading (status : Api.Status(a)) : Bool {
    case status {
      Api.Status.Loading => true
      => false
    }
  }

  fun errorsOf (key : String, status : Api.Status(a)) : Array(String) {
    case status {
      Api.Status.Error(errors) =>
        case Map.get(errors, key) {
          Just(value) => [value.message]
          => []
        }

      => []
    }
  }

  fun globalErrors (status : Api.Status(a)) {
    if let Errored(message) = status {
      <GlobalErrors errors={[message]}/>
    }
  }

  fun signIn (email : String, password : String) {
    let request =
      Http.post("/collections/users/auth-with-password")
      |> Http.jsonBody(encode { password: password, identity: email })
      |> Api.send(decode as SignInResponse)

    let status =
      await request

    if let Ok({ record: user, token: token }) = status {
      Application.login(user, token)
    }

    status
  }

  fun loadArticles (page : Number) : Promise(Api.Status(Articles)) {
    let params =
      SearchParams.empty()
      |> SearchParams.append("page", "#{page}")
      |> SearchParams.append("expand", "author")
      |> SearchParams.toString()

    Http.get("/collections/articles/records?#{params}")
    |> Http.jsonBody(encode { page: page })
    |> Api.send(decode as Articles)
  }

  fun send (
    request : Http.Request,
    decoder : Function(Object, Result(Object.Error, a))
  ) : Promise(Api.Status(a)) {
    let request =
      case Application.user {
        LoggedIn(user, Just(token)) =>
          Http.header(request, "Authorization", "Token #{token}")

        => request
      }

    let request =
      { request | url: "http://localhost:3001/api" + request.url }
      |> Http.header("Content-Type", "application/json")
      |> Http.send()

    let Ok(response) =
      await request or return Api.Status.Errored("Network error!")

    let JSON(object) =
      response.body or return Api.Status.Errored("Can't decode response!")

    case response.status {
      403 => Api.Status.Errored("Unauthorized!")

      400 =>
        {
          if let Ok(response) = (decode object as ErrorResponse) {
            if Map.isEmpty(response.data) {
              Api.Status.Errored(response.message)
            } else {
              Api.Status.Error(response.data)
            }
          } else {
            Api.Status.Errored("Could not decode the error response!")
          }
        }

      200 =>
        if let Ok(data) = decoder(object) {
          Api.Status.Ok(data)
        } else {
          dbg decoder(object)
          Api.Status.Errored("Could not decode the response entity!")
        }

      => Api.Status.Errored("Invalid request status!")
    }
  }
}

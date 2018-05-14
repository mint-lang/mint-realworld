store Stores.User {
  property loginStatus : Api.Status = Api.Status::Initial
  property status : Auth.Status = Auth.Status::Initial
  property currentUser : String = ""

  fun getCurrentUser : Void {
    do {
      token =
        Storage.Session.get("token")

      user =
        Http.get(Api.endpoint() + "/user")
        |> Http.header("Authorization", "Token " + token)
        |> Api.send(\object : Object => Object.Decode.string(object))
    } catch Storage.Error => error {
      next { state | status = Auth.Status::Unauthenticated }
    } catch Api.Status => status {
      next { state | status = Auth.Status::Unauthenticated }
    }
  }

  fun login (email : String, password : String) : Void {
    do {
      next { state | loginStatus = Api.nextStatus(loginStatus) }

      body =
        with Object.Encode {
          object(
            [
              field(
                "user",
                object(
                  [
                    field("email", string(email)),
                    field("password", string(password))
                  ]))
            ])
          |> Json.stringify()
        }

      user =
        Http.post(Api.endpoint() + "/users/login")
        |> Http.stringBody(body)
        |> Http.header("Content-Type", "application/json")
        |> Api.send(\object : Object => Object.Decode.string(object))
    } catch Api.Status => status {
      next { state | loginStatus = status }
    }
  }
}

store Stores.Tags {
  property tags : Array(String) = []
  property loading : Bool = false

  fun decodeTags (object : Object) : Result(Object.Error, Array(String)) {
    with Object.Decode {
      array(string, object)
    }
  }

  fun load : Void {
    with Http {
      do {
        next { state | loading = true }

        response =
          get(Api.endpoint() + "/tags")
          |> send()

        object =
          Json.parse(response.body)
          |> Maybe.toResult("")

        tags =
          with Object.Decode {
            field("tags", decodeTags, object)
          }

        next { state | tags = tags }
      } catch Http.ErrorResponse => error {
        void
      } catch Object.Error => error {
        void
      } catch String => error {
        void
      } finally {
        next { state | loading = false }
      }
    }
  }
}

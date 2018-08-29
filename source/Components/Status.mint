component Status {
  property status : Api.Status(a) = Api.Status::Initial
  property loadingMessage : String = ""
  property children : Array(Html) = []
  property message : String = ""

  style base {
    flex-direction: column;
    align-items: center;
    margin: 40px 0;
    display: flex;
  }

  style message {
    margin-bottom: 20px;
    font-weight: bold;
    color: #999;
  }

  get isLoading : Bool {
    Api.isLoading(status)
  }

  fun render : Html {
    case (status) {
      Api.Status::Error =>
        <div>
          <{ message }>
        </div>

      Api.Status::Ok =>
        <>
          <{ children }>
        </>

      Api.Status::Loading =>
        <div::base>
          <div::message>
            <{ loadingMessage }>
          </div>

          <Loader/>
        </div>

      Api.Status::Initial => <div/>
    }
  }
}

type Status {
  Error
  Ok
  Loading
  Initial
}

component Status {
  property status : Status = Status.Initial
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
    status == Status.Loading
  }

  fun render : Html {
    case status {
      Error =>
        <div::base>
          <div::message>
            message
          </div>
        </div>

      Ok =>
        <>
          children
        </>

      Loading =>
        <div::base>
          <div::message>
            loadingMessage
          </div>

          <Loader/>
        </div>

      Initial => <div/>
    }
  }
}

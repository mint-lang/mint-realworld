component Errors {
  property errors : Array(String) = []
  property prefix : String = ""

  style base {
    border-radius: 0 0 2px 2px;
    background: #f7b6b6;
    font-weight: bold;
    font-size: 14px;
    color: #902e2e;
    margin: 0;

    padding: 10px;
  }

  fun render : Html {
    if Array.isEmpty(errors) {
      <></>
    } else {
      <div::base>errors</div>
    }
  }
}

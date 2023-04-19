component GlobalErrors {
  property errors : Array(String) = []

  style base {
    margin-bottom: 20px;
    background: #f7b6b6;
    text-align: center;
    border-radius: 2px;
    font-weight: bold;
    font-size: 14px;
    color: #902e2e;
    padding: 20px;
  }

  fun renderError (error : String) : Html {
    <div>
      <{ error }>
    </div>
  }

  fun render : Html {
    if (Array.isEmpty(errors)) {
      Html.empty()
    } else {
      <div::base>
        <{ Array.map(errors, renderError) }>
      </div>
    }
  }
}

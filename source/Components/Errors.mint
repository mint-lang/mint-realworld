component GlobalErrors {
  property errors : Array(String) = []

  style base {
    padding: 20px;
    background: #f7b6b6;
    border-radius: 4px;
    color: #902e2e;
    margin-bottom: 20px;
    font-weight: bold;
    font-size: 14px;
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
        <{ Array.map(renderError, errors) }>
      </div>
    }
  }
}

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
    padding-left: 30px;
  }

  fun renderError (error : String) : Html {
    <li>
      <{ prefix + " " + error }>
    </li>
  }

  fun render : Html {
    if (Array.isEmpty(errors)) {
      Html.empty()
    } else {
      <ul::base>
        <{ Array.map(renderError, errors) }>
      </ul>
    }
  }
}

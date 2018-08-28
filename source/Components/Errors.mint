component GlobalErrors {
  property errors : Array(String) = []

  style base {
    padding: 20px;
    background: #e84848;
    border-radius: 4px;
    color: white;
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
    padding-left: 20px;
    font-weight: bold;
    margin-bottom: 0;
    margin-top: 5px;
    font-size: 14px;
    color: #e84848;
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

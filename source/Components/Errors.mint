component Errors {
  property errors : Array(String) = []
  property prefix : String = ""

  style base {
    padding-left: 20px;
    font-weight: bold;
    margin-bottom: 0;
    font-size: 14px;
    color: red;
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

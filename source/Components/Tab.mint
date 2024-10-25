component Tab {
  connect Theme exposing { primary }

  property active : Bool = false
  property label : String = ""
  property href : String = ""

  style base {
    border-bottom: 2px solid #{borderColor};
    text-decoration: none;
    padding: 10px 20px;
    font-weight: bold;
    color: #{color};
  }

  get borderColor : String {
    if active {
      primary
    } else {
      "#E9E9E9"
    }
  }

  get color : String {
    if active {
      primary
    } else {
      "inherit"
    }
  }

  fun render : Html {
    <a::base href={href}>label</a>
  }
}

component Pagination.Page {
  connect Theme exposing { primary }

  property active : Bool = false
  property href : String = ""
  property page : String = ""

  style base {
    box-shadow: 0px 1px 3px 0px rgba(0,0,0,0.1);
    background: #{background};
    text-decoration: none;
    border-radius: 2px;
    font-weight: bold;
    font-size: 14px;
    color: #{color};

    justify-content: center;
    display: inline-flex;
    align-items: center;
    height: 40px;
    width: 40px;
  }

  get background : String {
    if active {
      primary
    } else {
      "white"
    }
  }

  get color : String {
    if active {
      "white"
    } else {
      "inherit"
    }
  }

  fun render : Html {
    <a::base href={href}>
      page
    </a>
  }
}

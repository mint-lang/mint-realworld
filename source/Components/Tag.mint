component Tag {
  connect Theme exposing { primary, primaryText, primaryDark }

  property inactive : Bool = false
  property active : Bool = false
  property name : String = ""

  style base {
    pointer-events: {pointerEvents};
    background: {background};
    color: {primaryText};

    text-transform: uppercase;
    display: inline-block;
    text-align: center;
    border-radius: 2px;
    font-weight: bold;
    font-size: 12px;

    &:hover {
      background: {backgroundHover};
    }
  }

  style link {
    text-decoration: none;
    color: inherit;
    display: block;
    padding: 5px;
  }

  get pointerEvents : String {
    if (inactive) {
      "none"
    } else {
      ""
    }
  }

  get backgroundHover : String {
    if (active) {
      primaryDark
    } else {
      "#6b747b"
    }
  }

  get background : String {
    if (active) {
      primary
    } else {
      "#818a91"
    }
  }

  fun render : Html {
    <div::base>
      <a::link href={"/articles?tag=" + name + "&page=1"}>
        <{ name }>
      </a>
    </div>
  }
}

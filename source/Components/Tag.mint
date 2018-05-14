component Tag {
  connect Theme exposing { primary }

  property inactive : Bool = false
  property active : Bool = false
  property href : String = ""
  property name : String = ""

  style base {
    pointer-events: {pointerEvents};
    text-transform: uppercase;
    background: {background};
    display: inline-block;
    text-align: center;
    border-radius: 2px;
    font-weight: bold;
    font-size: 12px;
    color: #FFF;

    & a {
      display: block;
      padding: 5px;
    }

    &:hover {
      background: {backgroundHover};
    }
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
      "#46a046"
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
      <Link href={href}>
        <{ name }>
      </Link>
    </div>
  }
}

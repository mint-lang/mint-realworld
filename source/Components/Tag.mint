component Tag {
  connect Theme exposing { primary }

  property inactive : Bool = false
  property active : Bool = false
  property name : String = ""

  style base {
    pointer-events: {pointerEvents};
    text-transform: uppercase;
    background: {background};
    display: inline-block;
    text-align: center;
    border-radius: 12px;
    font-weight: bold;
    font-size: 12px;
    color: #FFF;

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
      <a::link href={"/articles?tag=" + name}>
        <{ name }>
      </a>
    </div>
  }
}

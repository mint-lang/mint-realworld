component Tag {
  property href : String = ""
  property name : String = ""

  style base {
    text-transform: uppercase;
    display: inline-block;
    background: #818a91;
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
      background: #6b747b;
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

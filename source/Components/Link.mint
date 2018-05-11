component Link {
  connect Theme exposing { link }

  property onClick : Maybe(Function(Html.Event, Void)) = Maybe.nothing()
  property children : Array(Html) = []
  property scrollToTop : Bool = true
  property target : String = ""
  property label : String = ""
  property href : String = ""

  style base {
    text-decoration: none;
    color: {link};
  }

  fun sameOrigin : Bool {
    windowUrl.origin != url.origin
  } where {
    windowUrl =
      Window.url()

    url =
      Url.parse(href)
  }

  fun handleClick (event : Html.Event) : Void {
    if (event.ctrlKey || event.button == 1 || sameOrigin()) {
      void
    } else {
      if (String.isEmpty(href)) {
        Html.Event.preventDefault(event)
      } else {
        do {
          Html.Event.preventDefault(event)
          action(event)

          if (scrollToTop) {
            Window.setScrollTop(0)
          } else {
            void
          }
        }
      }
    }
  } where {
    action =
      Maybe.withDefault(
        \event : Html.Event => Window.navigate(href),
        onClick)
  }

  fun render : Html {
    <a::base
      onClick={handleClick}
      target={target}
      href={href}>

      <{ label }>
      <{ children }>

    </a>
  }
}

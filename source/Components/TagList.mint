component TagList {
  property inactive : Bool = false
  property tags : Array(String) = []

  style base {
    > * {
      opacity: #{opacity};
      margin-bottom: 5px;
      margin-right: 5px;
    }
  }

  get opacity : Number {
    if (inactive) {
      0.5
    } else {
      1
    }
  }

  fun render : Html {
    <div::base>
      <{ renderdTags }>
    </div>
  } where {
    renderdTags =
      Array.map(
        (tag : String) : Html {
          <Tag
            inactive={inactive}
            name={tag}/>
        },
        tags)
  }
}

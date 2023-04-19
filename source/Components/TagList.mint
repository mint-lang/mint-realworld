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
      for (tag of tags) {
        <Tag
          inactive={inactive}
          name={tag}/>
      }
    </div>
  }
}

component Tagger {
  connect Theme exposing { primary, primaryText }

  property onChange : Function(Set(String), Promise(Never, Void)) =
    (value : Set(String)) : Promise(Never, Void) { next {  } }

  property tags : Set(String) = Set.empty()
  property placeholder : String = ""
  property disabled : Bool = false

  state tag : String = ""

  style base {
    flex-direction: column;
    display: flex;
  }

  style tag {
    text-transform: uppercase;
    background: #{color};
    color: #{primaryText};
    display: inline-flex;
    align-items: center;
    border-radius: 2px;
    margin-bottom: 5px;
    margin-right: 5px;
    padding: 5px 10px;
    font-weight: bold;
    font-size: 12px;
  }

  style icon {
    fill: currentColor;
    margin-left: 5px;
    cursor: pointer;
  }

  style tags {
    margin-bottom: -5px;
    margin-top: 5px;
    flex-wrap: wrap;
    display: flex;
  }

  get color : String {
    if (disabled) {
      "#999"
    } else {
      primary
    }
  }

  fun handleTag (value : String) : Promise(Never, Void) {
    next { tag = value }
  }

  fun handleBlur (event : Html.Event) : Promise(Never, Void) {
    next { tag = "" }
  }

  fun addTag : Promise(Never, Void) {
    if (Set.has(tag, tags)) {
      Promise.never()
    } else {
      sequence {
        onChange(Set.add(tag, tags))

        next { tag = "" }
      }
    }
  }

  fun removeTag (tag : String) : Promise(Never, Void) {
    onChange(Set.delete(tag, tags))
  }

  fun renderTag (tag : String) : Html {
    <div::tag>
      <{ tag }>

      <svg::icon
        onClick={(event : Html.Event) : Promise(Never, Void) { removeTag(tag) }}
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        height="12"
        width="12">

        <path
          d={
            "M12 0c-6.627 0-12 5.373-12 12s5.373 12 12 12 12-5.373 12" \
            "-12-5.373-12-12-12zm4.151 17.943l-4.143-4.102-4.117 4.15" \
            "9-1.833-1.833 4.104-4.157-4.162-4.119 1.833-1.833 4.155 " \
            "4.102 4.106-4.16 1.849 1.849-4.1 4.141 4.157 4.104-1.849" \
            " 1.849z"
          }/>

      </svg>
    </div>
  }

  fun render : Html {
    <div::base>
      <Input
        placeholder={placeholder}
        onChange={handleTag}
        disabled={disabled}
        onBlur={handleBlur}
        onEnter={addTag}
        value={tag}/>

      <div::tags>
        <{
          Set.map(renderTag, tags)
          |> Set.toArray()
        }>
      </div>
    </div>
  }
}

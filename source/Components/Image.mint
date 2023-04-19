enum Image.Status {
  Initial
  Invalid
  Ok
}

component Image {
  property borderRadius : String = "0"
  property height : String = "auto"
  property width : String = "auto"
  property src : String = ""

  state status : Image.Status = Image.Status::Initial

  style image {
    border-radius: #{borderRadius};
    transition: 320ms;
    opacity: #{opacity};
    object-fit: cover;
    height: #{height};
    display: block;
    width: #{width};
  }

  style base {
    border-radius: #{borderRadius};
    background: #AAA;
    height: #{height};
    width: #{width};
  }

  get opacity : Number {
    case (status) {
      Image.Status::Ok => 1
      => 0
    }
  }

  fun componentDidMount : Promise(Void) {
    let newStatus =
      await load()

    await next { status: newStatus }
  }

  fun load : Promise(Image.Status) {
    `
    new Promise((resolve, reject) => {
      let image = new Image()
      image.onerror = () => {resolve(#{Image.Status::Invalid})}
      image.onload = () => {resolve(#{Image.Status::Ok})}
      image.src = #{src}
    })
    `
  }

  fun render : Html {
    <div::base>
      <img::image src={src}/>
    </div>
  }
}

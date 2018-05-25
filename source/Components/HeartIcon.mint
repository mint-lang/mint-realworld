component HeartIcon {
  connect Theme exposing { link }

  property size : String = "15px"

  fun render : Html {
    <svg
      width={size}
      height={size}
      fill={link}
      viewBox="0 0 512 512">

      <g>
        <path
          d={
            "M256,448l-30.164-27.211C118.718,322.442,48,258.61,48,179" \
            ".095C48,114.221,97.918,64,162.4,64 c36.399,0,70.717,16.7" \
            "42,93.6,43.947C278.882,80.742,313.199,64,349.6,64C414.08" \
            "2,64,464,114.221,464,179.095 c0,79.516-70.719,143.348-17" \
            "7.836,241.694L256,448z"
          }/>
      </g>

    </svg>
  }
}

component Logo {
  property size : String = "24"

  style base {
    fill: currentColor;
  }

  fun render : Html {
    <svg::base
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      height={size}
      width={size}
    >
      <path
        d={
          "M16 0l-3 9h9l-1.866 2h-14.4l10.266-11zm2.267 13h-14.4l-1.867 " \
          "2h9l-3 9 10.267-11z"
        }
      />
    </svg>
  }
}

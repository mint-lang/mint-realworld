component Loader {
  property color : String = "#999"

  style base {
    height: 20px;
    width: 28px;
  }

  style line {
    background-color: {color};
    animation-fill-mode: both;
    display: inline-block;
    height: 20px;
    width: 4px;

    & + * {
      margin-left: 2px;
    }

    &:nth-child(1) {
      animation: line-scale 1s -0.4s infinite cubic-bezier(0.2, 0.68, 0.18, 1.08);
    }

    &:nth-child(2) {
      animation: line-scale 1s -0.3s infinite cubic-bezier(0.2, 0.68, 0.18, 1.08);
    }

    &:nth-child(3) {
      animation: line-scale 1s -0.2s infinite cubic-bezier(0.2, 0.68, 0.18, 1.08);
    }

    &:nth-child(4) {
      animation: line-scale 1s -0.1s infinite cubic-bezier(0.2, 0.68, 0.18, 1.08);
    }

    &:nth-child(5) {
      animation: line-scale 1s 0s infinite cubic-bezier(0.2, 0.68, 0.18, 1.08);
    }
  }

  fun render : Html {
    <div::base>
      <div::line/>
      <div::line/>
      <div::line/>
      <div::line/>
      <div::line/>
    </div>
  }
}

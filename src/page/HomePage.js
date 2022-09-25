import 'css-doodle'
import './style/HomePage.scss'

const HomePage = () => {
  return (
    <>
      <div className='home-bg' >
        <css-doodle grid="40x40">{`
    :doodle {
        @size: 100vw 20vmin;
    }
    :container {
        perspective: 100px;
        transform-style: preserve-3d;
    }
    position: absolute;
    top: 0;
    left: 0;
    width: 2px;
    height: 2px;
    border-radius: 50%;
    top: @r(1%, 100%, 1.5);
    left: @r(1%, 100%, 1.5);
    background: hsl(@rn(1, 255, 3), @rn(50%, 90%), @rn(70%, 90%));
    animation: move 10s infinite @r(-10, 0)s linear alternate;
    transform: rotate(@rn(720deg)) translate3d(@r(-50, 50)vmin, @r(-50, 50)vmin, @r(-1000, 0)px);
    zoom: @r(.1, 5, 3);
    box-shadow: 0 0 1px #fff, 0 0 3px #fff, 0 0 10px #fff;
    @keyframes move {
        100% {
            transform: rotate(0) translate3d(0, 0, 0);
        }
    }
    `}
        </css-doodle>
      </div>
    </>
  )
}

export default HomePage

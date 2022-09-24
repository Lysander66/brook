import { Row, Col, message } from 'antd'
import ReactPlayer from 'react-player'

const VideoPlayer = (props) => {
  const renderMulti = (urlList, n, s) => {
    const len = urlList.length
    const rows = urlList.filter((v, i) => { return i < len / n })
    return (
      <>
        {
          rows.map((v, i) => {
            return (
              <Row key={i} style={{ marginBottom: '2vh' }}>
                <Col key={n * i} span={24 / n} >
                  <ReactPlayer
                    className='react-player'
                    width={s.width}
                    height={s.height}
                    url={urlList[n * i]}
                    playing
                    controls
                    muted
                    config={{ file: { file: { forceFLV: true } } }
                    }
                  />
                </Col>
                {n * i + 1 < len && (
                  <Col key={n * i + 1} span={24 / n} >
                    <ReactPlayer
                      className='react-player'
                      width={s.width}
                      height={s.height}
                      url={urlList[n * i + 1]}
                      playing
                      controls
                      muted
                      config={{ file: { file: { forceFLV: true } } }
                      }
                    />
                  </Col>
                )}
                {n >= 3 && n * i + 2 < len && (
                  <Col key={n * i + 2} span={24 / n} >
                    <ReactPlayer
                      className='react-player'
                      width={s.width}
                      height={s.height}
                      url={urlList[n * i + 2]}
                      playing
                      controls
                      muted
                      config={{ file: { file: { forceFLV: true } } }
                      }
                    />
                  </Col>
                )}
              </Row>
            )
          })
        }
      </>
    )
  }

  const render = ({ urlList }) => {
    const len = urlList.length
    if (len <= 1) {
      return (
        <Row>
          <Col span={20} offset={4}>
            <ReactPlayer
              className='react-player'
              width='1280px'
              height='720px'
              url={len > 0 ? urlList[0] : ''}
              playing
              controls
              muted
              config={{ file: { file: { forceFLV: true } } }
              }
            />
          </Col>
        </Row>
      )
    } else if (len <= 4) {
      return renderMulti(urlList, 2, { width: '960px', height: '540px', })
    } else if (len <= 9) {
      return renderMulti(urlList, 3, { width: '640px', height: '360px', })
    }
    message.warn('最多支持9个哦')
    return <span>最多支持9个哦</span>
  }

  return render(props)
}

export default VideoPlayer

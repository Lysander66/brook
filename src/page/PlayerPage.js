import './style/PlayerPage.scss'
import VideoPlayer from '@/component/VideoPlayer'

import { useState } from 'react'
import { Row, Col, Button, Form, Input } from 'antd'

const PlayerPage = () => {
  const [urlRow, setUrlRow] = useState(1)
  const [urlList, setUrlList] = useState([])

  const onStreamUrlChange = (e) => {
    setUrlRow(e.target.value.trim().split('\n').length)
  }

  const onFinish = ({ streamUrl }) => {
    const _urlList = streamUrl.trim().split('\n').filter((s) => { return s.trim().length > 0 })
    setUrlList(_urlList.map(v => { return v.trim() }))
  }

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo)
  }

  return (
    <div className='playerDiv'>
      <Form
        name='basic'
        initialValues={{
          streamUrl: 'http://39.134.66.66/PLTV/88888888/224/3221225818/index.m3u8'
        }}
        labelCol={{ span: 8 }}
        wrapperCol={{ span: 16 }}
        onFinish={onFinish}
        onFinishFailed={onFinishFailed}
        colon={false}
        autoComplete='off'
      >
        <Row>
          <Col offset={4} span={10}>
            <Form.Item label='直播流' name='streamUrl' rules={[{ required: true }]}>
              <Input.TextArea onChange={onStreamUrlChange} rows={urlRow} placeholder='多个流地址，换行分隔' />
            </Form.Item>
          </Col>

          <Col span={2}>
            <Form.Item wrapperCol={{ offset: 8, span: 16 }}>
              <Button type='primary' htmlType='submit'>播放</Button>
            </Form.Item>
          </Col>
        </Row>
      </Form>

      <VideoPlayer urlList={urlList} />
    </div>
  )
}

export default PlayerPage

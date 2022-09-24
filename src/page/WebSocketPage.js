import './style/WebSocketPage.scss'
import { formatTimeMillis } from '@/util/time'
import SvelteJSONEditor from '@/component/SvelteJSONEditor'

import React, { useEffect, useState } from 'react'
import { Row, Col, Button, Form, Input, Switch, Timeline, message } from 'antd'

const WebSocketPage = () => {
  const [count, setCount] = useState(0)
  const [freeze, setFreeze] = useState(false)
  const [channel, setChannel] = useState('')
  const [lastMessage, setLastMessage] = useState({})
  const [messageHistory, setMessageHistory] = useState([])

  useEffect(() => {
    if (!channel || channel.length === 0) {
      return
    }
    setCount(count + 1)
    if (!freeze) {
      const obj = {
        json: JSON.parse(channel),
        label: `${formatTimeMillis(new Date())} len: ${channel.length}`,
      }
      setLastMessage(obj)
      setMessageHistory([obj, ...messageHistory.filter(function (v, i) { return i < 35 })])
    }
  }, [channel])

  const onFinish = (values) => {
    const { url } = values
    const conn = new WebSocket(url)
    conn.onmessage = (e) => {
      setChannel(e.data)
    }
    conn.onopen = function () {
      message.success('连接成功')
    }
    conn.onclose = function (e) {
      message.info('连接关闭')
    }
    conn.onerror = function (e) {
      message.error('Failed:', e)
    }
  }

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo)
  }

  const onChange = (checked) => {
    setFreeze(checked)
  }

  const handleClick = (e, index) => {
    setLastMessage(messageHistory[index])
  }

  const getColor = (i) => {
    if (i < 6) {
      return 'red'
    } else if (i < 16) {
      return 'green'
    } else if (i < 26) {
      return 'blue'
    }
    return 'gray'
  }

  return (
    <>
      <Form
        name='basic'
        labelCol={{ span: 8 }}
        wrapperCol={{ span: 16 }}
        initialValues={{
          url: '',
        }}
        onFinish={onFinish}
        onFinishFailed={onFinishFailed}
        colon={false}
        autoComplete='off'
        className='webSocketForm'
      >
        <Row>
          <Col span={10} >
            <Form.Item
              label='WebSocket'
              name='url'
              rules={[
                {
                  required: true,
                  message: 'Please input your url',
                },
              ]}
            >
              <Input />
            </Form.Item>
          </Col>

          <Col span={2}>
            <Form.Item wrapperCol={{ offset: 8, span: 16 }}>
              <Button disabled={count > 1} htmlType='submit' type='primary' shape='round'>
                {count > 1 ? count : '连接'}
              </Button>
            </Form.Item>
          </Col>

          <Col span={2} >
            <Form.Item name='freeze' label='freeze' valuePropName='checked'>
              <Switch onChange={onChange} />
            </Form.Item>
          </Col>
        </Row>
      </Form>

      <Row>
        <Col span={20} offset={1}>
          <SvelteJSONEditor content={lastMessage} />
        </Col>

        <Col offset={1}>
          <Timeline>
            {
              messageHistory.map((v, i) => {
                return (
                  <Timeline.Item key={i} color={getColor(i)}>
                    < span key={i} onClick={e => handleClick(e, i)} className='myTimeline'>
                      {v.label}
                    </span>
                  </Timeline.Item>
                )
              })
            }
          </Timeline>
        </Col>
      </Row>
    </>
  )
}

export default WebSocketPage

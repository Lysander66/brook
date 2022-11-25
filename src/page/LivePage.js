import './style/LivePage.scss'
import { formatTime } from '@/util/time'

import React, { useEffect, useState } from 'react'
import {
  Button,
  Card,
  Col,
  Row,
  Form,
  Radio,
  Select,
  Table,
  message,
} from 'antd'



const LivePage = () => {

  const [tableData, setTableData] = useState([])

  // 参数
  const [params, setParams] = useState({
    schema: 'rtmp',
    page: 1,
    pageSize: 15
  })

  // 查询列表
  useEffect(() => {
    const loadList = async (url = '') => {
      const response = await fetch(url, {
        method: 'GET',
        mode: 'cors',
        cache: 'no-cache',
        credentials: 'same-origin',
        headers: {
          'Content-Type': 'application/json'
        },
        redirect: 'follow',
        referrerPolicy: 'no-referrer',
      })
      return response.json()
    }

    let host = params.app === 'esport' ? 'http://18.162.167.111:8281' : 'http://18.166.66.37:8281'
    let url = `${host}/api/stat/all_group?schema=${params.schema}`
    loadList(url).then(data => {
      let list = []
      data.data.map(v => {
        v.createdAt = formatTime(v.createStamp)
        v.alive = Math.floor(v.aliveSecond / 60) + 'm ' + v.aliveSecond % 60 + 's'
        v.bitrate = Math.floor(v.bytesSpeed * 8 / 1000)
        v.tracks.map(t => {
          if (t.codec_id_name === 'H264') {
            v.fps = t.fps
            v.resolution = t.width + ' x ' + t.height + ' ' + t.codec_id_name
          } else {
            v.sample = t.sample_rate + ' x ' + t.sample_bit + ' ' + t.codec_id_name
          }
        })
        list.push(v)
      })
      setTableData(list)
    })
  }, [params])

  const onFinish = (values) => {
    setParams({
      ...params,
      ...values
    })
  }

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo)
  }

  const onChange = (e) => {
    console.log('radio checked', e.target.value)
    const _params = { app: e.target.value }
    setParams({
      ...params,
      ..._params
    })
  }

  const handleChange = (value) => {
    console.log(`selected ${value}`)
    const _params = { schema: value }
    setParams({
      ...params,
      ..._params
    })
  }

  // 翻页
  const onPageChange = (page) => {
    setParams({
      ...params,
      page
    })
  }


  const handleClick = (e, app, stream) => {
    let text = `https://pull.esportstv.vip/${app}/${stream}.flv`
    if (app === 'sport') {
      text += "\n"
      text += `https://d31284vz3u3dii.cloudfront.net/${app}/${stream}.live.flv`
      text += "\n"
      text += `http://52.81.27.195:8080/${app}/${stream}.live.flv`
    } else {
      text += "\n"
      text += `https://d1z6saveqyrmdf.cloudfront.net/${app}/${stream}.live.flv`
      text += "\n"
      text += `http://18.166.228.71:8080/${app}/${stream}.live.flv`
    }

    if (navigator.clipboard) {
      // clipboard api 复制
      navigator.clipboard.writeText(text)
    } else {
      let textarea = document.createElement('textarea')
      document.body.appendChild(textarea)
      // 隐藏此输入框
      textarea.style.position = 'fixed'
      textarea.style.clip = 'rect(0 0 0 0)'
      textarea.style.top = '10px'
      // 赋值
      textarea.value = text
      // 选中
      textarea.select()
      // 复制
      document.execCommand('copy', true)
      // 移除输入框
      document.body.removeChild(textarea)
    }

    message.success('copied')
  }

  const columns = [
    {
      title: 'stream',
      dataIndex: 'stream',
      render: stream => {
        return <span onClick={e => handleClick(e, params.app, stream)} className='streamName'>{stream}</span>
      },
    },
    {
      title: 'bit rate (kbit/s)',
      dataIndex: 'bitrate',
    },
    {
      title: 'fps',
      dataIndex: 'fps',
    },
    {
      title: 'resolution',
      dataIndex: 'resolution',
    },
    {
      title: 'sample',
      dataIndex: 'sample',
    },
    {
      title: 'alive',
      dataIndex: 'alive',
    },
    {
      title: 'createdAt',
      dataIndex: 'createdAt',
    },
  ]

  return (
    <>
      <Card >
        <Form
          name='basic'
          initialValues={{ app: 'sport', schema: 'rtmp' }}
          onFinish={onFinish}
          onFinishFailed={onFinishFailed}
          colon={false}
          autoComplete='off'
        >
          <Row>
            <Col span={3}>
              <Form.Item label='App' name='app'>
                <Radio.Group onChange={onChange} defaultValue='sport' buttonStyle='solid'>
                  <Radio.Button value='sport'>体育</Radio.Button>
                  <Radio.Button value='esport'>电竞</Radio.Button>
                </Radio.Group>
              </Form.Item>
            </Col>

            <Col span={3}>
              <Form.Item label='Schema' name='schema'>
                <Select onChange={handleChange} defaultValue='rtmp' placeholder="请选择">
                  <Select.Option value='rtmp'>rtmp</Select.Option>
                  <Select.Option value='rtsp'>rtsp</Select.Option>
                  <Select.Option value='fmp4'>fmp4</Select.Option>
                  <Select.Option value='hls'>hls</Select.Option>
                  <Select.Option value='ts'>ts</Select.Option>
                </Select>
              </Form.Item>
            </Col>

            <Col span={2}>
              <Form.Item>
                <Button htmlType='submit' type='primary' >查询</Button>
              </Form.Item>
            </Col>
          </Row>
        </Form>
      </Card>

      <Card title={`共查询到 ${tableData.length} 条结果`} style={{ 'textAlign': 'left' }}>
        <Table
          rowKey='id'
          columns={columns}
          dataSource={tableData}
          pagination={
            {
              current: params.page,
              pageSize: params.pageSize,
              total: tableData.length,
              onChange: onPageChange,
            }
          }
          bordered
        />
      </Card>
    </>
  )
}

export default LivePage

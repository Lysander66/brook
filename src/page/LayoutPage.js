import './style/LayoutPage.scss'
import { DEFINE_PATH } from '@/config/path'

import { useLocation, useNavigate, Outlet } from 'react-router-dom'
import {
  BackTop,
  Layout,
  Menu,
} from 'antd'
import {
  HomeOutlined,
  PlayCircleOutlined,
  WifiOutlined,
} from '@ant-design/icons'

const { Header, Content, Footer, Sider } = Layout


const LayoutPage = () => {
  const navigate = useNavigate()
  const { pathname } = useLocation()

  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Sider collapsible theme='light'>
        <div className='site-logo' />
        <Menu
          mode='inline'
          defaultSelectedKeys={pathname}
          selectedKeys={pathname}
          items={[
            {
              icon: <HomeOutlined />,
              label: 'Outline',
              key: 'root',
              onClick: () => { navigate(DEFINE_PATH.root) },
            },
            {
              icon: <PlayCircleOutlined />,
              label: 'Player',
              key: 'player',
              onClick: () => { navigate(DEFINE_PATH.player) },
            },
            {
              icon: <WifiOutlined />,
              label: 'WebSocket',
              key: 'websocket',
              onClick: () => { navigate(DEFINE_PATH.websocket) },
            }
          ]}
        />
      </Sider>

      <Layout className="site-layout">
        <Header className="site-layout-background" />
        <Content >
          <Outlet />
        </Content>
        <BackTop className="myBackTop" />
        <Footer>DevTools ©2022 Created by Lysander</Footer>
      </Layout>
    </Layout>
  )
}

export default LayoutPage

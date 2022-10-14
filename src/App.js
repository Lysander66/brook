import './App.css'
import { DEFINE_PATH } from './config/path'
import LayoutPage from './page/LayoutPage'
import HomePage from './page/HomePage'
import PlayerPage from './page/PlayerPage'
import WebSocketPage from './page/WebSocketPage'
import LivePage from './page/LivePage'
import LogPage from './page/LogPage'

import { BrowserRouter, Routes, Route } from 'react-router-dom'

function App () {
  return (
    <BrowserRouter>
      <div className="App">
        <Routes>
          <Route path='/' element={<LayoutPage />}>
            <Route index element={<HomePage />} />
            <Route path={DEFINE_PATH.player} element={<PlayerPage />} />
            <Route path={DEFINE_PATH.websocket} element={<WebSocketPage />} />
            <Route path={DEFINE_PATH.live} element={<LivePage />} />
            <Route path={DEFINE_PATH.log} element={<LogPage />} />
          </Route>
        </Routes>
      </div>
    </BrowserRouter>
  )
}

export default App

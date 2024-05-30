import * as React from 'react'
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom'
import { Main } from './ui/main/main'
import { NewGroupPage } from './ui/new-group-page/new-group-page'
import { FindGroupPage } from './ui/find-group-page/find-group-page'
import { PaymentPage } from './ui/payment-page/payment-page'

export const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Main/>}/>
        <Route path="/new" element={<NewGroupPage/>}/>
        <Route path="/:groupId" element={<FindGroupPage/>}/>
        <Route path="/:groupId/user/:userId" element={<PaymentPage/>}/>
      </Routes>
    </Router>
  )
}

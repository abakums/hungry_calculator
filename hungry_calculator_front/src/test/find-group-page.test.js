import React from 'react'
import { render, screen, act } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { FindGroupPage } from '../ui/find-group-page/find-group-page'
import { getGroupById } from '../api/get-group-by-id'

jest.mock('../api/get-group-by-id')

describe('Работа компонента FindGroupPage', () => {
  const mockGroupId = "1";
  
  beforeEach(() => {
    getGroupById.mockResolvedValue({
      detail: '',
      participants: [
        {id: "1", name: "Test User 1"},
        {id: "2", name: "Test User 2"}
      ]
    })
  })
  
  it('Рендеринг без ошибок', async () => {
    await act(async () => {
      render(
        <MemoryRouter initialEntries={[`/${mockGroupId}`]}>
          <Routes>
            <Route path='/:groupId' element={<FindGroupPage />} />
          </Routes>
        </MemoryRouter>
      )
    })
  })
  
  it('Должен отображать участников', async () => {
    await act(async () => {
      render(
        <MemoryRouter initialEntries={[`/${mockGroupId}`]}>
          <Routes>
            <Route path='/:groupId' element={<FindGroupPage />} />
          </Routes>
        </MemoryRouter>
      )
    })
    expect(await screen.findByText('Test User 1')).toBeInTheDocument()
    expect(await screen.findByText('Test User 2')).toBeInTheDocument()
  })
})
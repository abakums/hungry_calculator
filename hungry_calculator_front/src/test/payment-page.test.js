import React from 'react'
import { render, screen, act } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { PaymentPage } from '../ui/payment-page/payment-page'
import { getGroupById } from '../api/get-group-by-id'

jest.mock('../api/get-group-by-id')

describe('Работа компонента PaymentPage', () => {
  beforeEach(() => {
    getGroupById.mockResolvedValue({
      bill: [
        {
          payerId: '1',
        }
      ],
      requisites: 'test requisites'
    })
  })
  
  it('Рендеринг без ошибок', async () => {
    await act(async () => {
      render(<PaymentPage />, { wrapper: MemoryRouter })
    })
  })
  
  it('Должен отображать текст «Пользователь не найден», если нет соответствующего идентификатора пользователя', async () => {
    await act(async () => {
      render(<PaymentPage />, { wrapper: MemoryRouter })
    })
    expect(await screen.findByText('Пользователь не найден')).toBeInTheDocument()
  })
})
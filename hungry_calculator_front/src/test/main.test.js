import React from 'react';
import { render, fireEvent } from '@testing-library/react';
import { BrowserRouter as Router } from 'react-router-dom';
import { Main } from '../ui/main/main';

test('Работа компонента Main', () => {
  const { getByText } = render(
    <Router>
      <Main />
    </Router>
  );
  
  // Проверка, что компонент рендерится
  expect(getByText('ШерЧек')).toBeInTheDocument();
  
  // Имитируем событие клика
  fireEvent.click(getByText('Оплатить чек'));
  expect(getByText('Найти чек')).toBeInTheDocument();
});
import * as React from 'react'
import { Wrapper } from '../utils/wrapper/wrapper'
import s from './new-group-page.module.css'

export const NewGroupPage = () => {
  return (
    <Wrapper>
      <div className={s.root}>
        <a href={'/'} className={s.title}>ШерЧек</a>
        <div className={s.info}>Для разделения чека скачай приложение</div>
      </div>
    </Wrapper>
  )
}

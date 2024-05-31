import * as React from 'react'
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Wrapper } from '../utils/wrapper/wrapper'
import { getGroupById } from '../../api/get-group-by-id'
import s from './main.module.css'

export const Main = () => {
  const [inputIsOpen, setInputIsOpen] = useState(false)
  const [codeFound, setCodeFound] = useState(true)
  const [code, setCode] = useState(null)
  
  const navigate = useNavigate()
  
  const handleInputChang = (event) => {
    setCode(event.target.value)
    setCodeFound(true)
  }
  
  const handleSearchClick = () => {
    if (!code) {
      setCodeFound(false)
    } else {
      const curCode = parseInt(code.toString(), 10)
      getGroupById(curCode).then(r => {
        console.log(`На главной странице получены данные по группе ID=${curCode}`);
        if (r && r?.detail !== 'Страница не найдена.') {
          console.log(`Данные по группе ID=${curCode} валидны`);
          setCodeFound(true)
          return navigate(`/${curCode}`)
        } else {
          console.warn(`Данные по группе ID=${curCode} не валидны`);
          setCodeFound(false)
        }
      }).catch(() => {
        setCodeFound(false)
      })
    }
  }
  
  return (
    <Wrapper>
      <div className={s.root}>
        <a href={'/'} className={s.title}>ШерЧек</a>
        {inputIsOpen ?
          <div className={s.inputField}>
            <input className={s.input} placeholder="введите код" maxLength="4" onChange={handleInputChang}/>
            <div className={s.button} onClick={handleSearchClick}>Найти чек</div>
            {codeFound ? null : <p className={s.inputCaption}>код не найден</p>}
          </div>
          :
          <>
            <a onClick={() => setInputIsOpen(true)} className={s.button}>
              Оплатить чек
            </a>
            <a href={'/new'} className={s.button}>Разделить чек</a>
          </>
        }
      </div>
    </Wrapper>
  )
}

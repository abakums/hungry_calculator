import * as React from 'react'
import { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { useClipboard } from 'use-clipboard-copy'
import { Wrapper } from '../utils/wrapper/wrapper'
import { getGroupById } from '../../api/get-group-by-id'
import copyIcon from './copy-icon.svg'
import check from './check.svg'
import s from './payment-page.module.css'

export const PaymentPage = () => {
  const { groupId, userId } = useParams()
  const [bill, setBill] = useState([])
  const [hasInfo, setHasInfo] = useState(false)
  const [pageNotFound, setPageNotFound] = useState(true)
  const [requisites, setRequisites] = useState('')
  const [payerInfo, setPayerInfo] = useState({})
  
  const [block2IsOpen, setBlock2IsOpen] = useState(false)
  
  const [requisitesCopy, setRequisitesCopy] = useState(false)
  
  const clipboard = useClipboard()
  
  useEffect(() => {
    if (!hasInfo) {
      getGroupById(groupId).then(res => {
        console.log(`На странице оплаты получены данные по группе ID=${groupId}`);
        if (res && res.bill && res.requisites) {
          setBill(res.bill)
          setRequisites(res.requisites)
          setHasInfo(true)
        }
      })
    }
  }, [])
  
  useEffect(() => {
    if (bill[0]) {
      for (let i = 0; i < bill.length; i++) {
        console.log(bill[i].payerId)
        if (bill[i] && bill[i].payerId.toString() === userId) {
          setPayerInfo(bill[i])
          setPageNotFound(false)
        }
      }
    }
  }, [bill])
  
  return <Wrapper>
    {hasInfo ?
      <>
      {pageNotFound ?
        <p className={s.title}>Пользователь не найден</p>
        :
        <div className={s.root}>
          <p className={s.title}>{`Ваш чек ${payerInfo?.totalPrice} руб.`}</p>
          <div className={s.cutBlock}>
            <div className={s.header}>
              <p className={s.cutBlockTitle}>Реквизиты</p>
            </div>
            <div className={s.body}>
              <div className={s.requisites}>
                {requisites}
              </div>
            {requisitesCopy ?
              <div className={s.checkIcon}>
                <img src={check} alt={check}/>
              </div>
              :
              <div className={s.copyIcon} onClick={() => {
                clipboard.copy(requisites)
                setRequisitesCopy(true)
              }}>
                <img src={copyIcon} alt={copyIcon}/>
              </div>
            }
          </div>
        </div>
      
        <div className={s.cutBlock}>
          <div className={s.header} onClick={() => setBlock2IsOpen(!block2IsOpen)}>
            <p className={s.cutBlockTitle}>Информация о чеке</p>
          </div>
          {block2IsOpen ?
            <div className={s.body}>
              <div className={s.positionsList}>
                {payerInfo?.positions.map(position =>
                  <div className={s.position} key={position.id}>
                    <p className={s.positionTitle}>{position?.title}</p>
                    <p
                      className={s.positionCalculate}>{`${position?.price} x ${position?.personalParts} / ${position?.parts}`}</p>
                    <p className={s.positionPrice}>{position?.personalPrice} руб.</p>
                  </div>
                )}
              </div>
            </div>
            : null}
        </div>
      </div>
      }
      </>
      : null}
  </Wrapper>
}

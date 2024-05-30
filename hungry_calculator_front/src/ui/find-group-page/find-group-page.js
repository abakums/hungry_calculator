import * as React from 'react'
import { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { Wrapper } from '../utils/wrapper/wrapper'
import { getGroupById } from '../../api/get-group-by-id'
import s from './find-group-page.module.css'

export const FindGroupPage = () => {
  const { groupId } = useParams()
  const [participants, setParticipants] = useState([])
  const [hasInfo, setHasInfo] = useState(false)
  
  useEffect(() => {
    if (!hasInfo) {
      getGroupById(groupId).then(res => {
        console.log(res)
        if (res?.detail !== 'Страница не найдена.') {
          setParticipants(res.participants)
          setHasInfo(true)
        }
      })
    }
  }, [])
  
  return (
    <Wrapper>
      {hasInfo ?
        <div className={s.root}>
          <p className={s.title}>Выбери себя из списка</p>
          {participants.map(user => {
              return <a className={s.button}
                        href={`/${groupId}/user/${user.id}`}
                        key={user.id}
              >{user.name}</a>
            }
          )}
        </div>
        : null}
    </Wrapper>
  )
}

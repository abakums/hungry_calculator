import * as React from 'react';

import s from './wrapper.module.css';

export const Wrapper = ({children}) => {
  return (
    <div className={s.root}>
      {children}
    </div>
  );
}

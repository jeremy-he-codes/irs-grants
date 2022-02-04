import React, { useState } from 'react';

export const StoreContext = React.createContext(null);

export default ({ children }) => {
  const [filerDict, setFilerDict] = useState({});
  const [filingDict, setFilingDict] = useState({});

  const registerFiler = (filer) => {
    setFilerDict({
      ...filerDict,
      [filer.id]: filer,
    });
  };
  const registerFiling = (filing) => {
    setFilingDict({
      ...filingDict,
      [filing.id]: filing,
    });
  };

  const store = {
    filerDict,
    filingDict,
    registerFiler,
    registerFiling,
  };

  return (
    <StoreContext.Provider value={store}>{children}</StoreContext.Provider>
  );
};

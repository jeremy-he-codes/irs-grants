import React, { useState } from 'react';
import axios from 'axios';

const API_ROOT = '/api/v1';

const useFetch = (path, params = null) => {
  const [loading, setLoading] = useState(false);
  const [loaded, setLoaded] = useState(false);
  const [errored, setErrored] = useState(false);
  const [data, setData] = useState(null);

  const fetch = (overrideParams = null) => {
    setLoaded(false);
    setErrored(false);
    setLoading(true);

    axios.get(
      `${API_ROOT}/${path}`,
      { params: overrideParams || params }
    ).then((response) => {
      setLoaded(true);
      setData(response.data);
    }).catch((err) => {
      setLoaded(false);
      setErrored(true);
    }).finally(() => {
      setLoading(false);
    });
  };

  return [
    loading,
    loaded,
    errored,
    data,
    fetch
  ];
};

export default useFetch;

/* Skipped detailed error messages due to time constraint */

import React from 'react';
import { Alert, Button, Spin } from 'antd';

const StatusContainer = ({
  loaded,
  loading,
  errored,
  onRetry,
  children,
}) => {
  if (loaded) return children;
  if (errored) return (
    <Alert
      message="Something went wrong"
      type="error"
      {...(onRetry ? {
        action: <Button size="small" danger onClick={onRetry}>Retry</Button>
      } : {})}
    />
  );
  if (loading) return (
    <Spin />
  );

  return null;
};

export default StatusContainer;

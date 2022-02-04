import React from 'react';
import { Link } from 'react-router-dom';
import { Breadcrumb } from 'antd';

const AppBreadcrumb = ({
  items,
}) => (
  <Breadcrumb className="breadcrumb">
    {items.map(([path, title]) => {
      return (
        <Breadcrumb.Item key={path}>
          <Link to={path}>{title}</Link>
        </Breadcrumb.Item>
      );
    })}
  </Breadcrumb>
);

export default AppBreadcrumb;

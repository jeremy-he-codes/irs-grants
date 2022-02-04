import React, { useEffect, useContext } from 'react';
import { Table } from 'antd';
import { useNavigate } from 'react-router-dom';
import { StoreContext } from '../../Store';
import useFetch from '../../hooks/useFetch';
import StatusContainer from '../StatusContainer';
import AppBreadcrumb from '../Breadcrumb';

const filerColumns = [
  {
    title: 'EIN',
    dataIndex: 'ein',
    key: 'ein',
  },
  {
    title: 'Name',
    dataIndex: 'name',
  },
  {
    title: 'Address',
    key: 'address',
    render: (_, filer) => {
      if (!filer.address) return '-';

      const { address_line1: addressLine1, city, state, zip_code: zipCode } = filer.address;
      return (
        <span>{`${addressLine1}, ${city}, ${state} ${zipCode}`}</span>
      );
    },
  },
];

const Filers = () => {
  const navigate = useNavigate();
  const [
    listLoading,
    listLoaded,
    listErrored,
    list,
    fetchList
  ] = useFetch('filers');
  const { registerFiler } = useContext(StoreContext);

  useEffect(() => {
    fetchList();
  }, []);

  const handleFilerClick = (filer) => {
    registerFiler(filer);
    navigate(`/filers/${filer.id}`);
  };

  return (
    <section id="filers">
      <StatusContainer
        loading={listLoading}
        loaded={listLoaded}
        errored={listErrored}
        onRetry={() => fetchList()}
      >
        <Table
          columns={filerColumns}
          dataSource={list}
          pagination={false}
          rowKey="id"
          onRow={filer => ({
            onClick: () => handleFilerClick(filer),
          })}
        />
      </StatusContainer>
    </section>
  );
};

export default Filers;

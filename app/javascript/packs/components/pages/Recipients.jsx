import React, { useEffect, useState } from 'react';
import { Table, Divider } from 'antd';
import { format as prettyMoney } from 'money-formatter';
import useFetch from '../../hooks/useFetch';
import StatusContainer from '../StatusContainer';
import RecipientsFilter from '../RecipientsFilter';

const recipientColumns = [
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
    title: 'Grant Amount',
    dataIndex: 'amount',
    render: amount => amount ? prettyMoney('USD', amount, 0) : '-',
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

const Recipients = () => {
  const [
    listLoading,
    listLoaded,
    listErrored,
    list,
    fetchList
  ] = useFetch('recipients');
  const [search, setSearch] = useState({});

  useEffect(() => {
    fetchList(search);
  }, [search]);

  return (
    <section id="recipients">
      <RecipientsFilter onSubmit={setSearch} />

      <Divider />

      <StatusContainer
        loading={listLoading}
        loaded={listLoaded}
        errored={listErrored}
        onRetry={() => fetchList()}
      >
        <Table
          columns={recipientColumns}
          dataSource={list}
          pagination={false}
          rowKey="id"
        />
      </StatusContainer>
    </section>
  );
};

export default Recipients;

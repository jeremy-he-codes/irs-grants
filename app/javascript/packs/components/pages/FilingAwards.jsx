import React, { useEffect, useContext } from 'react';
import { Table } from 'antd';
import { useParams } from 'react-router-dom';
import { format as prettyMoney } from 'money-formatter';
import { StoreContext } from '../../Store';
import useFetch from '../../hooks/useFetch';
import StatusContainer from '../StatusContainer';
import AppBreadcrumb from '../Breadcrumb';

const awardColumns = [
  {
    title: 'Amount',
    dataIndex: 'amount',
    render: amount => prettyMoney('USD', amount, 0),
  },
  {
    title: 'Recipient',
    dataIndex: ['recipient', 'name'],
  },
  {
    title: 'IRC Section',
    dataIndex: 'irc_section',
  },
  {
    title: 'Grant Purpose',
    dataIndex: 'grant_purpose',
  },
];

const FilingAwards = () => {
  const { filingId } = useParams();
  const [
    listLoading,
    listLoaded,
    listErrored,
    list,
    fetchList
  ] = useFetch(`filings/${filingId}/awards`);
  const [
    _loading,
    _loaded,
    _error,
    filingDetails,
    fetchFiling,
  ] = useFetch(`filings/${filingId}`);
  const { filingDict, registerFiling } = useContext(StoreContext);
  const filing = filingDict[filingId];

  useEffect(() => {
    fetchList();

    if (!filing) {
      fetchFiling();
    }
  }, []);

  useEffect(() => {
    if (filingDetails) {
      registerFiling(filingDetails);
    }
  }, [filingDetails]);

  return (
    <section id="filing-awards">
      {filing && (
        <AppBreadcrumb
          items={[
            ['/', 'Filers'],
            [`/filers/${filing.filer.id}`, filing.filer.name],
            [`/filing/${filingId}`, filing['tax_year']],
          ]}
        />
      )}

      <StatusContainer
        loading={listLoading}
        loaded={listLoaded}
        errored={listErrored}
        onRetry={() => fetchList()}
      >
        <Table
          columns={awardColumns}
          dataSource={list}
          pagination={false}
          rowKey="id"
        />
      </StatusContainer>
    </section>
  );
};

export default FilingAwards;

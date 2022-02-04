import React, { useEffect, useContext } from 'react';
import { Table } from 'antd';
import { useNavigate, useParams } from 'react-router-dom';
import { StoreContext } from '../../Store';
import useFetch from '../../hooks/useFetch';
import StatusContainer from '../StatusContainer';
import AppBreadcrumb from '../Breadcrumb';

const filingColumns = [
  {
    title: 'Tax Year',
    dataIndex: 'tax_year',
  },
  {
    title: 'Period Begin Date',
    dataIndex: 'period_begin_date',
  },
  {
    title: 'Period End Date',
    dataIndex: 'period_end_date',
  },
];

const FilerFilings = () => {
  const { filerId } = useParams();
  const navigate = useNavigate();
  const [
    listLoading,
    listLoaded,
    listErrored,
    list,
    fetchList
  ] = useFetch(`filers/${filerId}/filings`);
  const [
    _loading,
    _loaded,
    _error,
    filerDetails,
    fetchFiler,
  ] = useFetch(`filers/${filerId}`);
  const { filerDict, registerFiler } = useContext(StoreContext);
  const filer = filerDict[filerId];

  useEffect(() => {
    fetchList();

    if (!filer) {
      fetchFiler();
    }
  }, []);

  useEffect(() => {
    if (filerDetails) {
      registerFiler(filerDetails);
    }
  }, [filerDetails]);

  const handleFilingClick = (filer) => {
    navigate(`/filings/${filer.id}`);
  };

  return (
    <section id="filer-filings">
      {filer && (
        <AppBreadcrumb
          items={[
            ['/', 'Filers'],
            [`/filers/${filerId}`, filer.name],
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
          columns={filingColumns}
          dataSource={list}
          pagination={false}
          rowKey="id"
          onRow={filing => ({
            onClick: () => handleFilingClick(filing),
          })}
        />
      </StatusContainer>
    </section>
  );
};

export default FilerFilings;

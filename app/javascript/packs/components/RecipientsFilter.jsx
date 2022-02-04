import React, { useState } from 'react';
import { InputNumber, Space, Button } from 'antd';

const RecipientsFilter = ({
  onSubmit
}) => {
  const [taxYear, setTaxYear] = useState(null);
  const [amountFrom, setAmountFrom] = useState(null);
  const [amountTo, setAmountTo] = useState(null);

  const handleSubmit = () => {
    onSubmit({
      amount_from: amountFrom,
      amount_to: amountTo,
      tax_year: taxYear,
    });
  };

  const handleClear = () => {
    setTaxYear(null);
    setAmountFrom(null);
    setAmountTo(null);

    handleSubmit();
  };

  return (
    <div className="recipient-filters">
      <Space>
        <InputNumber
          addonBefore="Amount From"
          addonAfter="$"
          min={0}
          max={amountTo || Infinity}
          value={amountFrom}
          onChange={setAmountFrom}
        />
        <InputNumber
          addonBefore="Amount To"
          addonAfter="$"
          min={amountFrom || 0}
          max={Infinity}
          value={amountTo}
          onChange={setAmountTo}
        />
        <InputNumber
          addonBefore="Tax Year"
          min={1950}
          max={new Date().getFullYear()}
          value={taxYear}
          onChange={setTaxYear}
        />
        <Button type="primary" onClick={handleSubmit}>Search</Button>
        {(taxYear || amountFrom || amountTo) && (
          <Button type="link" danger onClick={handleClear}>Clear</Button>
        )}
      </Space>
    </div>
  );
};

export default RecipientsFilter;

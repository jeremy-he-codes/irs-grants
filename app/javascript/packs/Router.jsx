import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Nav from './components/Nav';
import FilersPage from './components/pages/Filers';
import FilerFilingsPage from './components/pages/FilerFilings';
import FilingAwardsPage from './components/pages/FilingAwards';
import RecipientsPage from './components/pages/Recipients';

const Router = () => (
  <BrowserRouter>
    <Nav />
    <Routes>
      <Route path="/" exact element={<FilersPage />} />
      <Route path="/filers/:filerId" element={<FilerFilingsPage />} />
      <Route path="/filings/:filingId" element={<FilingAwardsPage />} />
      <Route path="/recipients" element={<RecipientsPage />} />
    </Routes>
  </BrowserRouter>
);

export default Router;

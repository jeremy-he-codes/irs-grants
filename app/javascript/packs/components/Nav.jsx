import React from 'react';
import { Link, useMatch } from 'react-router-dom';

const Nav = () => {
  const onRecipientPage = useMatch({ path: 'recipients', end: true });

  return (
    <nav>
      <Link to="/" style={{ textDecoration: onRecipientPage ? "none" : "underline" }} >Filers</Link>
      <Link to="/recipients" style={{ textDecoration: onRecipientPage ? "underline" : "none" }}>Recipients</Link>
    </nav>
  );
};

export default Nav;

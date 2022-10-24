import React from 'react';
import xsmall from '../../assets/images/hero-360w.jpg';
import small from '../../assets/images/hero-480w.jpg';
import medium from '../../assets/images/hero-768w.jpg';
import large from '../../assets/images/hero-1024w.jpg';
import xlarge from '../../assets/images/hero-1600w.jpg';

export default function Header() {
  return(
    <img src={xsmall}
         srcSet={`${xsmall} 360w, ${small} 480w, ${medium} 768w, ${large} 1024w, ${xlarge} 1600w`}
         alt="Burning couch with person in underwear reading newspaper"
         className="header__hero" />
  )
}

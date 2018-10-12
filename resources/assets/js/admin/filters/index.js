import moment from "moment";

const formatNumber = value =>
  value ? value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") : 0;

const formatPercentage = value => {
  if (!value || isNaN(value)) {
    return "...";
  }
  return `${parseFloat(Number(value).toFixed(2)).toString()}%`;
};

const formatToPercent = (value, max = 100, min = 0) =>
  `${((value - min) / (max - min) * 100).toFixed().toString()}%`; // eslint-disable-line no-mixed-operators

const centsToDollars = (numCents) => (numCents / 100).toLocaleString("en-US", {
  style: "currency",
  currency: "USD"
});

const floatToDollars = (floatDollars) => (floatDollars).toLocaleString("en-US", {
  style: "currency",
  currency: "USD"
});

const denormalize = function denormalize( res ) {

  if( !res ){
    return [];
  }
  
  if( !res.results ){
    return res;
  }

  return res.results.map( id => res.resultsMap[ id ] );
}

const dateToText = ( date ) => {
  return ( date ) ? moment( date ).format( 'MMM Do, YYYY h:mm:ss a' ) : '';
}

const itemStatusToText = ( isActive ) => {
  return ( isActive ) ? 'Enabled' : 'Disabled';
}

export const createFilters = Vue => {
  Vue.filter( "formatNumber", formatNumber);
  Vue.filter( "formatPercentage", formatPercentage);
  Vue.filter( "formatToPercent", formatToPercent);
  Vue.filter( "centsToDollars", centsToDollars);
  Vue.filter( "floatToDollars", floatToDollars);
  Vue.filter( "denormalize", denormalize);
  Vue.filter( "dateToText", dateToText);
  Vue.filter( "itemStatusToText", itemStatusToText);
};

export default createFilters;
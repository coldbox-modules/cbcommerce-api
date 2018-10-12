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

export const createFilters = Vue => {
  Vue.filter("formatNumber", formatNumber);
  Vue.filter("formatPercentage", formatPercentage);
  Vue.filter("formatToPercent", formatToPercent);
  Vue.filter("centsToDollars", centsToDollars);
  Vue.filter("floatToDollars", floatToDollars);
};

export default createFilters;
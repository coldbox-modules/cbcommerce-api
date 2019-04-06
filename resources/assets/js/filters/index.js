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

const denormalize = function denormalize(res) {

  if (!res) {
    return [];
  }

  if (!res.results) {
    return res;
  }

  return res.results.map(id => res.resultsMap[id]);
}

const dateToText = (date) => {
  return (date) ? moment(date).format('MMM Do, YYYY h:mm:ss a') : '';
}

const itemStatusToText = (isActive) => {
  return (isActive) ? 'Enabled' : 'Disabled';
}

const isImage = ( mediaItem ) => {
  let imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
  let pathParts = mediaItem.src.split( '.' );
  return imageExtensions.indexOf( pathParts[ pathParts.length - 1 ] ) > -1;
}

const removeHTML = ( html, truncateTo ) => {
    let textConversion = $( '<p>' + html + '</p>' ).text();
    if( truncateTo ){
        return Vue.options.filters.truncate( textConversion, truncateTo );
    } else {
        return textConversion;
    }
}

export const createFilters = Vue => {
  Vue.filter("formatNumber", formatNumber);
  Vue.filter("formatPercentage", formatPercentage);
  Vue.filter("formatToPercent", formatToPercent);
  Vue.filter("centsToDollars", centsToDollars);
  Vue.filter("floatToDollars", floatToDollars);
  Vue.filter("denormalize", denormalize);
  Vue.filter("dateToText", dateToText);
  Vue.filter("itemStatusToText", itemStatusToText);
  Vue.filter("isImage", isImage );
  Vue.filter("removeHTML", removeHTML );
};


export default createFilters;
import Vue from "vue";

const getLocationHostname = () => window.location.hostname;
const errorHandler = () => (err) => {
  if (err && err.response.body.error) {
    return err.response.body.messages.join(", ");
  } else if (err) {
    // all other error types we handle generically
    return err;
  }
};

export const config = {
  cookieName: "_DID",
  environment: {
    development: {
      api: {
        base        : '/store/api/v1/',
        token       : "",
        timeout     : 20000,
        errorHandler: errorHandler(),
      }
    },
    stage: {
      debug: false,
      api: {
        base        : '/store/api/v1/',
        timeout     : 10000,
        errorHandler: errorHandler(),
      }
    },
    production: {
      debug: false,
      api: {
        base        : '/store/api/v1/',
        timeout     : 10000,
        errorHandler: errorHandler(),
      }
    }
  }
};

export default config;

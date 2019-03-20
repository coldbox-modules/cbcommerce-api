import Axios from "axios";
import { getCookie } from "tiny-cookie";
import configuration from "./configuration";

const env = process.env.NODE_ENV || "development";
const base = configuration.environment[env].api.base;
const timeout = configuration.environment[env].api.timeout;
let token = configuration.environment[env].api.token;

if (!token) {
  try {
    token = getCookie("_DID");
  } catch (e) {
    console.error("Could not get token from config environment or from cookie");
  }
}

const useLoggers = apiInstance => {
  apiInstance.interceptors.request.use(
    config => {
      console.groupCollapsed(
        "%c Request: ",
        "color: #0dcfda; font-weight: bold",
        config.url
      );
      console.log(
        "%c Request Data:",
        "color: #03A9F4; font-weight: bold",
        config.data
      );
      return config;
    },
    error => {
      console.log(
        "%c !Request Error:",
        "color: #ff0808; font-weight: bold",
        error
      );
      console.groupEnd();
      return Promise.reject(error);
    }
  );
  apiInstance.interceptors.response.use(
    response => {
      console.log(
        "%c Responce Data:",
        "color: #4CAF50; font-weight: bold",
        response.data
      );
      console.groupEnd();
      return response;
    },
    error => {
      console.log(
        "%c Response Error:",
        "color: #ff0808; font-weight: bold",
        error
      );
      console.groupEnd();
      return Promise.reject(error);
    }
  );
  return apiInstance;
};

const apiAxios = Axios.create({
  baseURL: base,
  timeout,
  headers : {
    "Authorization": `Bearer ${token}`,
    "Content-Type" : "application/json",
    "CSRF-Token": window.cbcGlobalData ? window.cbcGlobalData[ "@token" ] : ""
  }
});


const finalAPI = apiAxios;

export default finalAPI;

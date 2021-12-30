import axios from "axios";
import { history } from "./routing";

const instance = axios.create({
  baseURL: "http://localhost:4000/api",
  withCredentials: true,
});

instance.defaults.headers.common["Content-Type"] = "application/json";
instance.defaults.timeout = 3 * 1000;

const token = localStorage.getItem("token");
//Adds token to Authorization header if it is not null
if (token !== null) {
  instance.defaults.headers.common["Authorization"] = "Bearer " + token;
}

//Telling axios to throw an error if the response status is not between 200 and 299
instance.defaults.validateStatus = (status: number) => {
  return status >= 200 && status < 300;
};
instance.interceptors.response.use(undefined, (error) => {
  if (
    axios.isAxiosError(error) &&
    (error.response?.status === 403 || error.response?.status === 401)
  ) {
    if (error.response.data["new_token"]) {
      localStorage.setItem("token", error.response.data["new_token"]);
      instance.defaults.headers.common["Authorization"] =
        "Bearer " + error.response.data["new_token"];
      error.config.headers!["Authorization"] =
        "Bearer " + error.response.data["new_token"];

      return instance.request(error.config);
    } else {
      history.push("/signin");
      history.go(0);
    }
  }
  return Promise.reject(error);
});

export default instance;

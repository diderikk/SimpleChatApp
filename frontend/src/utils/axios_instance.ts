import axios from "axios";

const instance = axios.create({
  baseURL: "http://localhost:4000/api"
});


axios.defaults.headers.common['Content-Type'] = 'application/json';

const token = localStorage.getItem("token");
//Adds token to Authorization header if it is not null
if (token !== null) {
  instance.defaults.headers.common["Authorization"] =
    "Bearer " + token;
}

//Telling axios to throw an error if the response status is not between 200 and 299
instance.defaults.validateStatus = (status: number) => {
  return status >= 200 && status < 300;
};


export default instance;

import axios from "./axios_instance";
import UserInterface from "../interfaces/user.interface";
import User from "../interfaces/user.interface";

interface SignIn {
  email: string;
  password: string;
}

interface SignUp {
  user: {
    email: string;
    password: string;
    name: string;
  };
}

interface SignUpResponse {
  token: string;
  user: User;
}

export const signIn = async (
  email: string,
  password: string
): Promise<void> => {
  try {
    const data = { email, password } as SignIn;
    const response = await axios.post("/signin", data);
    localStorage.setItem("token", response.data.token);
    axios.defaults.headers.common["Authorization"] = response.data.token;
  } catch (error) {
    //Error handling
  }
};

export const signUp = async (
  username: string,
  email: string,
  password: string
): Promise<UserInterface | null> => {
  try {
    const data = { user: { email, password, name: username } } as SignUp;

    const response = await axios.post<SignUpResponse>("/signup", data);
    localStorage.setItem("token", response.data.token);
    axios.defaults.headers.common["Authorization"] = response.data.token;
    return response.data.user;
  } catch (error) {
    //Error handling
    return null;
  }
};

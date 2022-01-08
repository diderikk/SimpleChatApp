import axios from "./axios_instance";
import UserInterface from "../interfaces/user.interface";
import User from "../interfaces/user.interface";
import ListChat from "../interfaces/listChat.interface";
import { Chat } from "../interfaces/chat.interface";
import { Message } from "../interfaces/message.interface";

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

interface UserListResponse {
  chats: ListChat[];
  invited_chats: ListChat[];
}

interface TokenResponse {
  token: string;
  user_id: number;
}

export const signIn = async (
  email: string,
  password: string
): Promise<boolean> => {
  try {
    const data = { email, password } as SignIn;
    const response = await axios.post("/signin", data);
    localStorage.setItem("token", response.data.token);
    axios.defaults.headers.common["Authorization"] =
      "Bearer " + response.data.token;
    return true;
  } catch (error) {
    //Error handling
    return false;
  }
};

export const signUp = async (
  username: string,
  email: string,
  password: string
): Promise<UserInterface | undefined> => {
  try {
    const data = { user: { email, password, name: username } } as SignUp;

    const response = await axios.post<SignUpResponse>("/signup", data);
    localStorage.setItem("token", response.data.token);
    axios.defaults.headers.common["Authorization"] =
      "Bearer " + response.data.token;
    return response.data.user;
  } catch (error) {
    //Error handling
    return undefined;
  }
};

export const getUserList = async (): Promise<UserListResponse | undefined> => {
  try {
    const response = await axios.get<UserListResponse>("/users/chats");
    return response.data;
  } catch (error) {
    // TODO: ERror handling
    return undefined;
  }
};

export const acceptInvitation = async (chatId: number): Promise<boolean> => {
  try {
    await axios.put(`/users/invited_chats/${chatId}`);
    return true;
  } catch (error) {
    console.log(error);
    return false;
  }
};

export const declineInvitation = async (chatId: number): Promise<boolean> => {
  try {
    await axios.delete(`/users/invited_chats/${chatId}`);
    return true;
  } catch (error) {
    console.log(error);
    return false;
  }
};

export const getChat = async (chatId: number): Promise<Chat | undefined> => {
  try {
    const response = await axios.get<Chat>(`/chats/${chatId}`);
    return response.data;
  } catch (error) {
    // TODO: Error handling
    return undefined;
  }
};

export const getChannelToken = async (
  chatId: number
): Promise<TokenResponse | undefined> => {
  try {
    const response = await axios.get<TokenResponse>(
      `/chats/${chatId}/channel_token`
    );
    return response.data;
  } catch (error) {
    return undefined;
  }
};

export const getNextPage = async (
  chatId: number,
  page: number
): Promise<Message[]> => {
  try {
    const response = await axios.get<Message[]>(`/chats/${chatId}/${page}`);
    return response.data;
  } catch (error) {
    return [];
  }
};

export const createChat = async (
  userEmails: string[]
): Promise<ListChat | undefined> => {
  try {
    const response = await axios.post<ListChat>("/users/chats", {
      user_list: userEmails,
    });
    return response.data;
  } catch (error) {
    return undefined;
  }
};

import { createContext, Dispatch, SetStateAction } from "react";
import User from "../interfaces/user.interface";


type UserContextType = {
	user: User | undefined | null,
	setUser:  Dispatch<SetStateAction<User | undefined>> | undefined,
}

export const UserContext = createContext<UserContextType>({
	user: undefined,
	setUser: undefined
});
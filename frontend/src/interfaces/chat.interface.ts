import { Message } from "./message.interface";

export interface Chat {
	id: number;
	users: string[];
	messages: Message[];
}
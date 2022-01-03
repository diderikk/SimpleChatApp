import { Center, HStack, Image, Text, VStack } from "@chakra-ui/react";
import Chat from "../interfaces/listChat.interface";
import userIcon from "../assets/man.png";
import {navigate} from "../utils/routing"

interface Props {
  chat: Chat;
}

export const ChatListItem: React.FC<Props> = ({ chat }) => {
  const truncUsersText = (users: string[]): string => {
    let usersText = users.join(", ");
    if (usersText.length > 30) return usersText.substring(0, 27) + "...";
    return usersText;
  };

  const truncMessageText = (message: string): string => {
    if (message.length > 30) return message.substring(0, 27) + "...";
    return message;
  };

  return (
    <Center
      backgroundColor="white"
      p="10px"
      w={{ base: "20rem", md: "30rem" }}
      h={{ base: "7rem", md: "11rem" }}
      borderRadius="lg"
      justifyContent="flex-start"
      my="20px"
      cursor="pointer"
      onClick={() => navigate(`/chats/${chat.id}`)}
    >
      <HStack>
        <Image
          borderRadius="full"
          src={userIcon}
          boxSize={{ base: "70px", md: "100px" }}
          mr="10px"
        />
        <VStack alignItems="flex-start">
          <Text
            whiteSpace="nowrap"
            color="black"
            overflow="hidden"
            fontWeight="bold"
            fontSize={{ base: "0.8rem", md: "1.3rem" }}
          >
            {truncUsersText(chat.users)}
          </Text>
          <Text
            whiteSpace="nowrap"
            color="gray"
            fontSize={{ base: "0.8rem", md: "1.1rem" }}
          >
            {truncMessageText(chat.message)}
          </Text>
        </VStack>
      </HStack>
    </Center>
  );
};

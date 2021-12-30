import { Button, Center, HStack, Image, Text, VStack } from "@chakra-ui/react";
import Chat from "../interfaces/listChat.interface";
import userIcon from "../assets/man.png";

interface Props {
  chat: Chat;
}

export const InvitedListItem: React.FC<Props> = ({ chat }) => {
  const users = ["Diderik", "Diderik", "Diderik", "Diderik", "Diderik"];

  const truncUsersText = (users: string[]): string => {
    let usersText = users.join(", ");
    if (usersText.length > 20) return usersText.substring(0, 17) + "...";
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
      justifyContent="space-between"
      my="20px"
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
            {truncUsersText(users)}
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
      <Center flexDirection="column">
        <Button
          colorScheme="green"
          mr="10px"
          fontSize={{ base: "0.8rem", md: "1rem" }}
		  w={{base: "60px", md: "100px"}}
		  mb="10px"
        >
          Accept
        </Button>
        <Button
          colorScheme="red"
          mr="10px"
          fontSize={{ base: "0.8rem", md: "1rem" }}
		  w={{base: "60px", md: "100px"}}

        >
          Decline
        </Button>
      </Center>
    </Center>
  );
};

import { Box, Flex, Text } from "@chakra-ui/react";
import { Message } from "../interfaces/message.interface";

interface Props {
  message: Message;
}

export const MessageItem: React.FC<Props> = ({
  message: { user, isMe, at, content },
}) => {
  const chatDate = (dateStr: string) => {
    const date = new Date(dateStr);
    const today = new Date();
    if (date.toDateString() === today.toDateString())
      return date.toUTCString().substring(17, 22);
    if (date.getFullYear() === today.getFullYear())
      return (
        date.toUTCString().substring(4, 12) +
        date.toUTCString().substring(16, 22)
      );

    return date.toUTCString().substring(4, 22);
  };
  return (
    <Flex
      flexDirection="column"
      mb="20px"
      ml={isMe ? { base: "55%", sm: "50%", md: "65%" } : "0"}
      w={{ base: "150px", sm: "150px", md: "180px", lg: "230px", xl: "300px" }}
    >
      <Text
        px="7px"
        userSelect="none"
        fontSize={{ base: "0.7rem", md: "0.9rem" }}
      >
        {user}
      </Text>
      <Box
        backgroundColor="blue.400"
        borderRadius="lg"
        p="10px"
        fontSize={{ base: "0.8rem", md: "1.1rem" }}
      >
        <Text>{content}</Text>
      </Box>
      <Text
        px="7px"
        userSelect="none"
        fontSize={{ base: "0.7rem", md: "0.9rem" }}
      >
        {chatDate(at)}
      </Text>
    </Flex>
  );
};

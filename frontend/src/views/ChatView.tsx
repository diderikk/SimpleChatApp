import {
  Button,
  Center,
  Flex,
  Image,
  Input,
  InputGroup,
  InputRightElement,
  Spinner,
  Text,
} from "@chakra-ui/react";
import { ChangeEvent, useCallback, useEffect, useMemo, useRef, useState } from "react";
import { useParams } from "react-router-dom";
import { MessageItem } from "../component/MessageItem";
import { Chat } from "../interfaces/chat.interface";
import { getChat, getChannelToken } from "../utils/actions";
import { navigate } from "../utils/routing";
import sendIcon from "../assets/send.png";
import { Socket, Channel } from "phoenix";
import { Message } from "../interfaces/message.interface";

interface MessageInput {
  content: string;
  user: string;
  at: string;
  user_id: number;
}

export const ChatView: React.FC = () => {
  const params = useParams();
  const [chat, setChat] = useState<Chat | undefined>(undefined);
  const [messageList, setMessageList] = useState<Message[]>([]);
  const [messageInput, setMessageInput] = useState<string>("");
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [channelToken, setChannelToken] = useState<string>("");
  const [userId, setUserId] = useState<number>(0);
  const socket = useMemo(
    () =>
      new Socket("ws://localhost:4000/socket", {
        params: { token: channelToken },
      }),
    [channelToken]
  );
  const [chatChannel, setChatChannel] = useState<Channel | undefined>(
    undefined
  );
  const bottomRef = useRef<HTMLDivElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  // const 

  socket.onOpen(() => {
    setChatChannel(socket.channel("chat:" + parseInt(params["chatId"]!)));
  });
  socket.onError(async () => {
    const token = await getChannelToken(parseInt(params["chatId"]!));
    if (!token) navigate("/chatlist");

    setChannelToken(token?.token!);
  });
  socket.onClose(() => console.log("CLOSE"));

  const userText = useCallback((users: string[]) => {
    let text = users.join(", ");
    if (text.length! > 30) return text.substring(0, 27) + "...";
    return text;
  }, []);

  const handleInputChange = (event: ChangeEvent<HTMLInputElement>) => {
    setMessageInput(event.target.value);
  };

  const handleSend = async () => {
    chatChannel!.push("message", { content: messageInput });
    setMessageInput("");
  };

  const handleEnterPress = async (
    event: React.KeyboardEvent<HTMLInputElement>
  ) => {
    if (event.key === "Enter") {
      await handleSend();
    }
  };

  const initializeChat = useCallback(async () => {
    if (!params["chatId"]) navigate("/chatlist");
    const response = await getChat(parseInt(params["chatId"]!));
    const channelTokenResponse = await getChannelToken(
      parseInt(params["chatId"]!)
    );
    console.log(response);
    if (!response || !channelTokenResponse) navigate("/chatlist");
    setChannelToken(channelTokenResponse?.token!);
    setUserId(channelTokenResponse?.user_id!);
    setMessageList(response?.messages!);
    response!.messages = [];
    setChat(response!);
    setIsLoading(false);
  }, [params]);

  const addMessageToChat = useCallback((message: Message) => {
    setMessageList([...messageList, message]);
  }, [messageList]);

  useEffect(() => {
    if (!socket.isConnected() && channelToken) {
      socket.connect();
    }
  }, [socket, channelToken]);

  useEffect(() => {
    if (
      chatChannel &&
      chatChannel.state !== "joined" &&
      chatChannel.state !== "joining"
    ) {
      chatChannel
        ?.join()
        .receive("ok", (resp) => {
          console.log("Joined successfully", resp);
        })
        .receive("error", (resp) => {
          console.log("Unable to join", resp);
        });
      chatChannel.on("joined", (resp) => {
        console.log("Joined", resp);
      });
      chatChannel.on("message", (messageInput: MessageInput) => {
        const message = {
          ...messageInput,
          isMe: messageInput.user_id === userId,
        } as Message;
        addMessageToChat(message);
      });
    }
  }, [chatChannel, userId, addMessageToChat]);

  useEffect(() => {
    initializeChat();
  }, [initializeChat]);

  useEffect(() => {
    if(bottomRef.current)
      bottomRef.current.scrollIntoView({behavior: "smooth"})
  }, [messageList, containerRef])

  const ButtonIcon: React.FC = () => {
    return <Image w="17px" src={sendIcon} />;
  };

  if (isLoading)
    return (
      <Center
        h="100%"
        w="100%"
        py="30px"
        pb="10vh"
        bg="tomato"
        color="white"
        fontSize="2xl"
        flexDirection="column"
      >
        <Spinner
          thickness="6px"
          speed="0.65s"
          emptyColor="gray.200"
          color="blue.500"
          size="xl"
        />
      </Center>
    );

  return (
    <Center
      h="100%"
      w="100%"
      py="30px"
      justifyContent="flex-start"
      flexDirection="column"
    >
      <Text fontSize={{ base: "2xl", md: "4xl" }}>
        {userText(chat?.users!)}
      </Text>
      <Flex
        my="5vh"
        overflowX="hidden"
        overflowY="auto"
        width={{ base: "90%", md: "70%" }}
        flexDir="column"
        h="100vh"
        ref={containerRef}
      >
        {messageList &&
          messageList.map((message) => (
            <MessageItem message={message} key={message.at} />
          ))}
          <div style={{ float:"left", clear: "both" }} ref={bottomRef}>
        </div>
      </Flex>

      <InputGroup width={{ base: "90%", md: "35%" }} h="60px">
        <Input
          color="black"
          value={messageInput}
          backgroundColor="white"
          onChange={handleInputChange}
          onKeyPress={(e) => handleEnterPress(e)}
          isDisabled={!chatChannel}
        />
        <InputRightElement width="-40px">
          <Button
            size="md"
            colorScheme="blue"
            rightIcon={<ButtonIcon />}
            onClick={() => handleSend()}
            isDisabled={!chatChannel}
          >
            Send
          </Button>
        </InputRightElement>
      </InputGroup>
    </Center>
  );
};

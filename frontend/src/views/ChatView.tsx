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
import { ChangeEvent, useCallback, useEffect, useRef, useState } from "react";
import { useParams } from "react-router-dom";
import { MessageItem } from "../component/MessageItem";
import { Chat } from "../interfaces/chat.interface";
import { getChat, getChannelToken, getNextPage } from "../utils/actions";
import { navigate } from "../utils/routing";
import sendIcon from "../assets/send.png";
import { Socket, Channel, Presence } from "phoenix";
import { Message } from "../interfaces/message.interface";
import { ArrowBackIcon } from "@chakra-ui/icons";
import { APIHost } from "../utils/axiosInstance";

interface MessageInput {
  id: number;
  content: string;
  user: string;
  at: string;
  user_id: number;
}

interface PresenceUser {
  id: string;
  user: string;
}

export const ChatView: React.FC = () => {
  const params = useParams();
  const [chat, setChat] = useState<Chat | undefined>(undefined);
  const [messageList, setMessageList] = useState<Message[]>([]);
  const [messageInput, setMessageInput] = useState<string>("");
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [isFetching, setIsFetching] = useState<boolean>(false);
  const [channelToken, setChannelToken] = useState<string>("");
  const [userId, setUserId] = useState<number>(0);
  const [socket, setSocket] = useState<Socket>(null!);
  const [chatChannel, setChatChannel] = useState<Channel | undefined>(
    undefined
  );
  const bottomRef = useRef<HTMLDivElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const [page, setPage] = useState<number>(1);
  const [presence, setPresence] = useState<Presence>(null!);
  const [presentUsers, setPresentUsers] = useState<PresenceUser[]>([]);

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
    if (!response || !channelTokenResponse) navigate("/chatlist");
    setChannelToken(channelTokenResponse?.token!);
    setUserId(channelTokenResponse?.user_id!);
    setMessageList(response?.messages!);
    response!.messages = [];
    setChat(response!);
    setIsLoading(false);
  }, [params]);

  useEffect(() => {
    if (!socket && channelToken) {
      const socket = new Socket(`ws://${APIHost}/socket`, {
        params: { token: channelToken },
      });
      socket.onError(async () => {
        const token = await getChannelToken(parseInt(params["chatId"]!));
        if (!token) navigate("/chatlist");

        setChannelToken(token?.token!);
      });

      socket.connect();
      setSocket(socket);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [socket, channelToken]);

  useEffect(() => {
    if (!chatChannel && socket) {
      const channel = socket.channel("chat:" + parseInt(params["chatId"]!));
      channel.on("joined", (resp) => {
        console.log("Joined", resp);
      });
      channel.on("message", (messageInput: MessageInput) => {
        const message = {
          ...messageInput,
          isMe: messageInput.user_id === userId,
        } as Message;
        setMessageList((messageList) => [...messageList, message]);
      });
      channel
        .join()
        .receive("ok", (resp) => {
          console.log("Joined successfully", resp);
          setPresence(new Presence(channel));
          setChatChannel(channel);
        })
        .receive("error", (resp) => {
          console.log("Unable to join", resp);
        });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [chatChannel, socket]);

  useEffect(() => {
    initializeChat();
  }, [initializeChat]);

  useEffect(() => {
    if (presence) {
      presence.onSync(() => {
        setPresentUsers([]);
        presence.list((id, { user }) => {
          setPresentUsers((presentUsers) => [...presentUsers, { id, user }]);
        });
      });
    }
  }, [presence]);

  const onScroll = async () => {
    if (
      containerRef.current &&
      containerRef.current.scrollTop === 0 &&
      page > 0
    ) {
      setIsFetching(true);
      const nextPage = await getNextPage(parseInt(params["chatId"]!), page);
      if (nextPage.length === 0) {
        setIsFetching(false);
        setPage(-1);
        return;
      }
      setPage(page + 1);
      setMessageList([...nextPage, ...messageList]);
    }
  };

  useEffect(() => {
    if (bottomRef.current)
      if (!isFetching) bottomRef.current.scrollIntoView({ behavior: "smooth" });
      else setIsFetching(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [messageList, containerRef.current]);

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
      justifyContent="flex-start"
      flexDirection="column"
    >
      <ArrowBackIcon
        fontSize={{ base: "2xl", md: "4xl" }}
        position="absolute"
        left={{ base: "50px", md: "100px" }}
        top="37px"
        onClick={() => navigate("/chatlist")}
        cursor="pointer"
      />

      <Text fontSize={{ base: "2xl", md: "4xl" }} ml="">
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
        onScroll={onScroll}
      >
        <Spinner
          thickness="20px"
          speed="1s"
          emptyColor="gray.200"
          color="blue.200"
          size="md"
          margin="auto"
          mt="10px"
          borderRadius="10"
          visibility={isFetching ? "visible" : "hidden"}
        />
        {messageList &&
          messageList.map((message) => (
            <MessageItem message={message} key={message.id} />
          ))}
        <div style={{ float: "left", clear: "both" }} ref={bottomRef}></div>
      </Flex>

      <InputGroup width={{ base: "90%", md: "35%" }} h="60px" mb="10px">
        <Input
          color="black"
          value={messageInput}
          backgroundColor="white"
          onChange={handleInputChange}
          onKeyPress={(e) => handleEnterPress(e)}
          isDisabled={!(chatChannel && chatChannel.state === "joined")}
        />
        <InputRightElement width="-40px">
          <Button
            size="md"
            colorScheme="blue"
            rightIcon={<ButtonIcon />}
            onClick={() => handleSend()}
            isDisabled={!(chatChannel && chatChannel.state === "joined")}
          >
            Send
          </Button>
        </InputRightElement>
      </InputGroup>
      <Text color="gray.400" fontSize="md">
        Online: {presentUsers.map((user) => user.user).join(", ")}
      </Text>
    </Center>
  );
};

import { Center, HStack, Spinner } from "@chakra-ui/react";
import { useCallback, useEffect, useMemo, useState } from "react";
import { getUserList } from "../utils/actions";
import ListChat from "../interfaces/listChat.interface";
import { ChatListItem } from "../component/ChatListItem";
import { SelectButton } from "../component/SelectButton";
import { InvitedListItem } from "../component/InvitedListItem";

export const ChatList: React.FC = () => {
  const [chatList, setChatList] = useState<ListChat[]>([]);
  const [invitedList, setInvitedList] = useState<ListChat[]>([]);
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [chatSelected, setChatSelected] = useState<boolean>(true);

  const invertSelect = () => {
    setChatSelected(!chatSelected);
  };

  const chatListMapped = useMemo(() => {
    return chatList.map((chat) => <ChatListItem chat={chat} key={chat.id} />);
  }, [chatList]);

  const moveChatItem = useCallback(
    (chat: ListChat) => {
      setInvitedList(invitedList.filter((item) => item.id !== chat.id));
      setChatList([chat, ...chatList]);
      setChatSelected(true);
    },
    [invitedList, chatList]
  );

  const removeChatItem = useCallback(
    (chat: ListChat) => {
      setInvitedList(invitedList.filter((item) => item.id !== chat.id));
    },
    [invitedList]
  );

  const invitedListMapped = useMemo(() => {
    return invitedList.map((chat) => (
      <InvitedListItem
        removeChatItem={removeChatItem}
        moveChatItem={moveChatItem}
        chat={chat}
        key={chat.id}
      />
    ));
  }, [invitedList, moveChatItem, removeChatItem]);

  const fetchChatList = useCallback(async () => {
    const response = await getUserList();
    console.log(response);
    setChatList(response?.chats!);
    setInvitedList(response?.invited_chats!);
    setIsLoading(false);
  }, []);

  useEffect(() => {
    fetchChatList();
  }, [fetchChatList]);

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
      pb="10vh"
      bg="tomato"
      color="white"
      fontSize="2xl"
      flexDirection="column"
      justifyContent="flex-start"
      userSelect="none"
    >
      <HStack>
        <SelectButton
          isSelected={chatSelected}
          setIsSelected={invertSelect}
          content="Chats"
        />
        <SelectButton
          isSelected={!chatSelected}
          setIsSelected={invertSelect}
          content="Invited"
        />
      </HStack>
      {chatSelected ? chatListMapped : invitedListMapped}
    </Center>
  );
};

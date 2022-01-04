import {
  Button,
  FormControl,
  FormLabel,
  Input,
  InputGroup,
  InputRightElement,
  Modal,
  ModalBody,
  ModalCloseButton,
  ModalContent,
  ModalFooter,
  ModalHeader,
  ModalOverlay,
  FormHelperText,
  FormErrorMessage,
  SimpleGrid,
  Center,
} from "@chakra-ui/react";
import { ChangeEvent, useRef, useState } from "react";
import ListChat from "../interfaces/listChat.interface";
import { createChat } from "../utils/actions";

interface Props {
  isOpen: boolean;
  onClose: () => void;
  addChatListItem: (chatListItem: ListChat) => void;
}

export const CreateChatModal: React.FC<Props> = ({
  isOpen,
  onClose,
  addChatListItem,
}) => {
  const [userEmails, setUserEmails] = useState<string[]>([]);
  const [emailInput, setEmailInput] = useState<string>("");
  const [isError, setIsError] = useState<boolean>(false);
  const initialRef = useRef<HTMLInputElement>(null);

  const handleAddEmail = () => {
    console.log(emailInput);
    if (emailInput === "") return;
    if (
      /^[^\s]+@[^\s]+$/i.test(emailInput) &&
      !userEmails.includes(emailInput)
    ) {
      setUserEmails((emails) => [emailInput, ...emails]);
      setIsError(false);
      setEmailInput("");
    } else {
      setIsError(true);
    }
  };

  const handleEnterPress = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === "Enter") {
      handleAddEmail();
    }
  };

  const handleRemoveEmail = (emailToBeRemoved: string) => {
    setUserEmails(userEmails.filter((email) => email !== emailToBeRemoved));
  };

  const handleInputChange = (event: ChangeEvent<HTMLInputElement>) => {
    setEmailInput(event.target.value);
  };

  const handleCreate = async () => {
    const newChat = await createChat(userEmails);
    if (!newChat) return;

    addChatListItem(newChat);
    setUserEmails([]);
    setEmailInput("");
    onClose();
  };
  return (
    <Modal isOpen={isOpen} onClose={onClose} initialFocusRef={initialRef}>
      <ModalOverlay />

      <ModalContent>
        <ModalHeader>Create a chat</ModalHeader>
        <ModalCloseButton />

        <ModalBody pb={6}>
          <FormControl mt={4} isInvalid={isError}>
            <FormLabel>Email</FormLabel>
            <InputGroup>
              <Input
                value={emailInput}
                onChange={(e) => handleInputChange(e)}
                focusBorderColor="grey"
                ref={initialRef}
                placeholder="Email"
                color="black"
                type="email"
                onKeyPress={(e) => handleEnterPress(e)}
              />
              <InputRightElement width="-30px">
                <Button colorScheme="green" onClick={() => handleAddEmail()}>
                  +
                </Button>
              </InputRightElement>
            </InputGroup>
            {!isError ? (
              <FormHelperText>
                Enter the email of a user you want to invite
              </FormHelperText>
            ) : (
              <FormErrorMessage>
                Not a correct email or email already exists
              </FormErrorMessage>
            )}
          </FormControl>
          <SimpleGrid minChildWidth="100%" spacing="10px">
            {userEmails.map((email) => (
              <Center
                backgroundColor="gray.200"
                p="5px 10px"
                borderRadius="lg"
                justifyContent="space-between"
              >
                {email}
                <Button
                  background="gray.200"
                  height="10px"
                  onClick={() => handleRemoveEmail(email)}
                  _focus={{ border: "none" }}
                >
                  -
                </Button>
              </Center>
            ))}
          </SimpleGrid>
        </ModalBody>

        <ModalFooter>
          <Button colorScheme="blue" mr={3} onClick={() => handleCreate()}>
            Create
          </Button>
          <Button onClick={onClose}>Cancel</Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
};

import { Button, Center } from "@chakra-ui/react";
import {getUser} from "../utils/actions"

export const ChatList: React.FC = () => {
	const getMe = async (id: number) => {
		const response = await getUser(id);
		console.log(response);
	}
  return (
    <Center
      h="100vh"
      w="100%"
      py="30px"
      pb="10vh"
      bg="tomato"
      color="white"
      fontSize="2xl"
      flexDirection="column"
    >
		<Button size="lg" onClick={() => getMe(1)}>CLick me</Button>
	</Center>
  );
};

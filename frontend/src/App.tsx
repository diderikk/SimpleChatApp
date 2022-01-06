import { Router, Route, Routes } from "react-router-dom";
import { SignUp } from "./views/SignUp";
import { SignIn } from "./views/SignIn";
import { ChatList } from "./views/ChatList";
import { Center } from "@chakra-ui/react";
import { history } from "./utils/routing";
import { ChatView } from "./views/ChatView";

function App() {
  return (
    <Center
      h="100vh"
      w="100%"
      pb="10px"
      pt="30px"
      bg="tomato"
      color="white"
      fontSize="2xl"
    >
      <Router navigator={history} location={history.location}>
        <Routes>
          <Route path="/signup" element={<SignUp />} />
          <Route path="/signin" element={<SignIn />} />
          <Route path="/chatlist" element={<ChatList />} />
          <Route path="/chats/:chatId" element={<ChatView />} />
          <Route path="/" element={<ChatList />} />
        </Routes>
      </Router>
    </Center>
  );
}

export default App;

import { Router, Route, Routes } from "react-router-dom";
import { SignUp } from "./views/SignUp";
import { UserContext } from "./context/UserContext";
import User from "./interfaces/user.interface";
import { useState } from "react";
import { SignIn } from "./views/SignIn";
import { ChatList } from "./views/ChatList";
import { Center } from "@chakra-ui/react";
import { history } from "./utils/routing";
import { ChatView } from "./views/ChatView";

function App() {
  const [user, setUser] = useState<User | undefined>(undefined);


  return (
    <Center
      h="100vh"
      w="100%"
      py="30px"
      bg="tomato"
      color="white"
      fontSize="2xl"
    >
      <UserContext.Provider value={{ user, setUser }}>
          <Router navigator={history} location={history.location}>
            <Routes>
              <Route path="/signup" element={<SignUp />} />
              <Route path="/signin" element={<SignIn />} />
              <Route path="/chatlist" element={<ChatList />} />
              <Route path="/chats/:chatId" element={<ChatView />} />
            </Routes>
          </Router>
      </UserContext.Provider>
    </Center>
  );
}

export default App;

import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import { SignUp } from "./views/SignUp";
import { UserContext } from "./context/UserContext";
import User from "./interfaces/user.interface";
import { useState } from "react";
import { SignIn } from "./views/SignIn";
import { ChatList } from "./views/ChatList";

function App() {
  const [user, setUser] = useState<User | undefined>(undefined);

  return (
    <UserContext.Provider value={{ user, setUser }}>
      <div className="App">
        <Router>
          <Routes>
            <Route path="/signup" element={<SignUp />} />
            <Route path="/signin" element={<SignIn />} />
            <Route path="/chatlist" element={<ChatList />} />
          </Routes>
        </Router>
      </div>
    </UserContext.Provider>
  );
}

export default App;

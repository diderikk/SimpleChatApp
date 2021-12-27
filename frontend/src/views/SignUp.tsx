import { Center, Flex, Input, Spacer, Stack, Text } from "@chakra-ui/react";
import React, { useState } from "react";
import { useForm } from "../utils/useForm";

interface RegisterForm {
  username: string;
  email: string;
  password: string;
  confirmPassword: string;
}

export const SignUp: React.FC = () => {
  const [inputValues, setInputValues] = useForm<RegisterForm>({
    username: "",
    email: "",
    password: "",
    confirmPassword: "",
  });

  //   const [usernameError, setUsernameError] = useState<string>("");
  //   const [emailError, setEmailError] = useState<string>("");
  //   const [passwordError, setPasswordErrror] = useState<string>("");
  //   const [confirmPasswordError, setConfirmPasswordError] = useState<string>("");

  return (
    <Center
      h="100vh"
      w="100%"
	  py="20px"
      bg="tomato"
      color="white"
      fontSize="2xl"
      flexDirection="column"
      justifyContent="space-evenly"
    >
      <Text fontSize="6xl">Sign Up</Text>
      <Center flexDirection="column" h="40vh">
        <Input
          name="username"
          value={inputValues.username}
          type="text"
          placeholder="Username"
          onChange={setInputValues}
          size="lg"
          variant="flushed"
          isRequired={true}
          _placeholder={{ color: "white" }}
        />
        <Spacer />
        <Input
          name="email"
          value={inputValues.email}
          type="text"
          placeholder="Email"
          onChange={setInputValues}
          size="lg"
          variant="flushed"
          isRequired={true}
          _placeholder={{ color: "white" }}
        />
        <Spacer />

        <Input
          name="password"
          value={inputValues.password}
          type="password"
          placeholder="Password"
          onChange={setInputValues}
          size="lg"
          variant="flushed"
          errorBorderColor="red.300"
          isRequired={true}
          _placeholder={{ color: "white" }}
        />
        <Spacer />

        <Input
          name="confirmPassword"
          value={inputValues.confirmPassword}
          type="password"
          placeholder="Confirm Password"
          onChange={setInputValues}
          size="lg"
          variant="flushed"
          errorBorderColor="red.300"
          isRequired={true}
          _placeholder={{ color: "white" }}
        />
      </Center>
    </Center>
  );
};

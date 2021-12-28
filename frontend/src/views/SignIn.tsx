import { Button, Center, Input, Spacer, Stack, Text } from "@chakra-ui/react";
import React, { useState } from "react";
import { useForm } from "../utils/useForm";
import { signIn } from "../utils/actions";
import { useNavigate } from "react-router-dom";

interface SignInForm {
  email: string;
  password: string;
}

export const SignIn: React.FC = () => {
  const [inputValues, setInputValues] = useForm<SignInForm>({
    email: "",
    password: "",
  });

  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [signInError, setSignInError] = useState<string>("");
  const navigate = useNavigate();

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setIsLoading(true);

    const signedIn = await signIn(inputValues.email, inputValues.password);

    if (!signedIn) {
      setIsLoading(false);
      setSignInError("Wrong email or password");
      return;
    }

    navigate("/");
  };

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
      <Text fontSize="6xl" userSelect="none" mb="10vh">
        Sign In
      </Text>
      <form onSubmit={(event) => handleSubmit(event)}>
        <Center flexDirection="column" h="25vh">
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
            isRequired={true}
            _placeholder={{ color: "white" }}
            mb="25px"
          />
          <Spacer />
          <Stack h="10vh" alignItems="center">
            <Button
              cursor="pointer"
              colorScheme="cyan"
              type="submit"
              size="lg"
              w="20vh"
              loadingText="Submitting"
              isLoading={isLoading}
			  mb="10px"
            >
              Submit
            </Button>
            <Text fontSize="md" color="red.700">
              {signInError}
            </Text>
          </Stack>
        </Center>
      </form>
    </Center>
  );
};

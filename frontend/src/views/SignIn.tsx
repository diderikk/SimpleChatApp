import { Button, Center, Input, Spacer, Text, Link } from "@chakra-ui/react";
import React, { useState } from "react";
import { useForm } from "../utils/useForm";
import { signIn } from "../utils/actions";
import {history} from "../utils/routing"

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

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setIsLoading(true);

    const signedIn = await signIn(inputValues.email, inputValues.password);

    if (!signedIn) {
      setIsLoading(false);
      setSignInError("Wrong email or password");
      return;
    }
    history.push("/chatlist");
    history.go(0);
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
          <Center h="10vh">
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
          </Center>
          <Text fontSize="md">No account? <Link color="cyan.700" href="/signup">Sign Up</Link></Text>
        </Center>
      </form>
    </Center>
  );
};

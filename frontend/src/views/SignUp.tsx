import { Button, Center, Input, Spacer, Stack, Text } from "@chakra-ui/react";
import React, { useState } from "react";
import { useForm } from "../utils/useForm";
import {
  validateConfirmPassword,
  validateEmail,
  validatePassword,
  validateUsername,
} from "../utils/signUpValidation";
import { signUp } from "../utils/actions";
import { useNavigate } from "react-router-dom";

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

  const [usernameError, setUsernameError] = useState<string>("");
  const [emailError, setEmailError] = useState<string>("");
  const [passwordError, setPasswordErrror] = useState<string>("");
  const [confirmPasswordError, setConfirmPasswordError] = useState<string>("");
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const navigate = useNavigate();

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!validateAll()) return;
    setIsLoading(true);

    const response = await signUp(
      inputValues.username,
      inputValues.email,
      inputValues.password
    );

    if (response === undefined) {
      setEmailError("Email already taken");
      setIsLoading(false);
      return;
    }

    navigate("/");
  };

  const validateAll = () => {
    let valid = true;

    if (!validateUsername(inputValues.username, setUsernameError))
      valid = false;
    if (!validateEmail(inputValues.email, setEmailError)) valid = false;
    if (!validatePassword(inputValues.password, setPasswordErrror))
      valid = false;
    if (
      !validateConfirmPassword(
        inputValues.password,
        inputValues.confirmPassword,
        setConfirmPasswordError
      )
    )
      valid = false;

    return valid;
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
        Sign Up
      </Text>
      <form onSubmit={(event) => handleSubmit(event)}>
        <Center flexDirection="column" h="40vh">
          <Stack>
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
              onBlur={() =>
                validateUsername(inputValues.username, setUsernameError)
              }
            />
            <Text color="red.700" fontSize="sm">
              {usernameError}
            </Text>
          </Stack>

          <Spacer />
          <Stack>
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
              onBlur={() => validateEmail(inputValues.email, setEmailError)}
            />
            <Text color="red.700" fontSize="sm">
              {emailError}
            </Text>
          </Stack>
          <Spacer />

          <Stack>
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
              onBlur={() =>
                validatePassword(inputValues.password, setPasswordErrror)
              }
            />
            <Text color="red.700" fontSize="sm">
              {passwordError}
            </Text>
          </Stack>
          <Spacer />

          <Stack mb="25px">
            <Input
              name="confirmPassword"
              value={inputValues.confirmPassword}
              type="password"
              placeholder="Confirm Password"
              onChange={setInputValues}
              size="lg"
              variant="flushed"
              isRequired={true}
              _placeholder={{ color: "white" }}
              onBlur={() =>
                validateConfirmPassword(
                  inputValues.password,
                  inputValues.confirmPassword,
                  setConfirmPasswordError
                )
              }
            />
            <Text color="red.700" fontSize="sm">
              {confirmPasswordError}
            </Text>
          </Stack>
          <Spacer />
          <Button
            cursor="pointer"
            colorScheme="cyan"
            type="submit"
            size="lg"
            w="20vh"
            loadingText="Submitting"
            isLoading={isLoading}
          >
            Submit
          </Button>
        </Center>
      </form>
    </Center>
  );
};

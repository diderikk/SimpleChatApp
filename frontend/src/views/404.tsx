import { Center, Text } from "@chakra-ui/react";

export const Page404: React.FC = () => {
  return (
    <Center flexDirection="column" userSelect="none" mb="40vh">
      <Text fontSize="8xl">404</Text>
      <Text>Page not found</Text>
    </Center>
  );
};

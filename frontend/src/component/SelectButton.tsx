import { Button } from "@chakra-ui/react";

interface Props {
  isSelected: boolean;
  setIsSelected: () => void;
  content: string;
}

export const SelectButton: React.FC<Props> = ({ isSelected, setIsSelected, content }) => {
  const handleClick = () => {
    if(!isSelected)
      setIsSelected();
  }

  return (
    <Button
      width={{base: "150px", md: "300px"}}
      my="30px"
      color="black"
      _focus={{ outline: "none" }}
      _hover={{}}
      backgroundColor={isSelected ? "grey" : ""}
      onClick={() => handleClick()}
    >
      {content}
    </Button>
  );
};

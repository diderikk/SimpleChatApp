export const validateUsername = (
  username: string,
  setUsernameError: React.Dispatch<React.SetStateAction<string>>
): boolean => {
  if (username.trim().length === 0) {
    setUsernameError("Username field is empty");
    return false;
  } else {
    setUsernameError("");
    return true;
  }

  // Check if field is already taken
};

export const validateEmail = (
  email: string,
  setEmailError: React.Dispatch<React.SetStateAction<string>>
): boolean => {
  if (email.trim().length === 0) {
    setEmailError("Email field is empty");
    return false;
  }
  // eslint-disable-next-line no-useless-escape
  else if (!/^[A-Za-z0-9+_.-]+@(.+)$/.test(email)) {
    setEmailError("This is not an email");
    return false;
  } else {
    setEmailError("");
    return true;
  }

  // Check if field is already taken
};

export const validatePassword = (
  password: string,
  setPasswordError: React.Dispatch<React.SetStateAction<string>>
): boolean => {
  let hasNumber = false;
  let hasCapitalLetter = false;
  Array.from(password).forEach((char) => {
    if (/^\d+$/.test(char)) hasNumber = true;
    else if (char === char.toUpperCase()) hasCapitalLetter = true;
  });
  if (password.trim().length === 0) {
    setPasswordError("Password field is empty");
    return false;
  } else if (password.length < 8) {
    setPasswordError("Password must contain 8 characters");
    return false;
  } else if (!hasCapitalLetter || !hasNumber) {
    setPasswordError("Missing numbers and capital letters");
    return false;
  } else {
    setPasswordError("");
    return true;
  }
};

export const validateConfirmPassword = (
  password: string,
  confirmPassword: string,
  setConfirmPasswordError: React.Dispatch<React.SetStateAction<string>>
): boolean => {
  if (password !== confirmPassword) {
    setConfirmPasswordError("Passwords do not match");
    return false;
  }
  setConfirmPasswordError("");
  return true;
};

import { body } from "express-validator";
import { validate } from "../validate";

export const validateRegister = validate([
  body("username")
    .isLength({ min: 3 })
    .withMessage("Tên phải có ít nhất 3 ký tự")
    .matches(/^[a-zA-Z0-9_]+$/)
    .withMessage("Tên chỉ được chứa chữ cái, số và dấu gạch dưới"),
  body("email").isEmail().withMessage("Email không hợp lệ"),
  body("phoneNumber")
    .optional()
    .matches(/^\d{10,11}$/)
    .withMessage("Số điện thoại không hợp lệ"),
  body("password")
    .isLength({ min: 6 })
    .withMessage("Mật khẩu phải có ít nhất 6 ký tự"),
]);

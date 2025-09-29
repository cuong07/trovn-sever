export const MomoConfig = {
  accessKey: process.env.MOMO_ACCESS_KEY,
  secretKey: process.env.MOMO_SECRET_KEY,
  partnerCode: "MOMO",
  partnerName: "TROVN",
  redirectUrl: "https://trovn.io.vn/payment/momo",
  ipnUrl: "https://api.trovn.io.vn/api/v1/payment/momo/callback",
  extraData: "",
  orderGroupId: "",
  autoCapture: true,
  lang: "vi",
};

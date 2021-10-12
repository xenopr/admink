export const tokenConfig = {
  secret: process.env.TOKENSECRET || "no secret",
  live: process.env.TOKENLIVE || "24h"
};

export const adConfig:any = {
  url: process.env.AD_URL || "",
  baseDN: process.env.AD_BASEDN || "",
  username: process.env.AD_USERNAME || "",
  password: process.env.AD_PASSWORD || "",
  attributes: {
    user: [
      "cn",
      "dn",
      "mail",
      "displayName",
      "Department",
      "distinguishedName",
      "sAMAccountName",
      "userPrincipalName",
      "myCustomAttribute",
      "userPrinicipalName",
      "objectGUID",
      "objectSid",
      "extensionAttribute1",
      "extensionAttribute2",
      "extensionAttribute3",
      "extensionAttribute4",
      "extensionAttribute5",
      "extensionAttribute6",
    ],
    group: [],
  },
};
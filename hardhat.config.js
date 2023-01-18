require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
  solidity: "0.8.17",
  networks: {
    canto: {
      url: "https://eth.plexnode.wtf/",
      chainId: 740,
      accounts: [process.env.PRIVATE_KEY]
    },
  }
};
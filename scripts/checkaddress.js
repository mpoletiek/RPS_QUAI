// scripts/checkAddress.js
const { Wallet } = require('ethers');
require('dotenv').config();

async function main() {
  const wallet = new Wallet(process.env.PRIVATE_KEY);
  console.log("Wallet address:", wallet.address);
}

main();

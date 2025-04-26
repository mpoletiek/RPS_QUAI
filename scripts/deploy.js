const { quais } = require("quais");
const MyTokenJson = require('../artifacts/contracts/MyToken.sol/MyToken.json')
const { deployMetadata } = require("hardhat")
require('dotenv').config()

async function main() {
    try {
        console.log("🚀 Starting ERC20 Token Deployment...");

        // Validate required environment variables
        const requiredEnvVars = ['RPC_URL', 'CYPRUS1_PK', 'INITIAL_OWNER'];
        const missingVars = requiredEnvVars.filter(varName => !process.env[varName]);
        if (missingVars.length > 0) {
            throw new Error(`Missing required environment variables: ${missingVars.join(', ')}`);
        }

        // Setup Deployer Account
        const provider = new quais.JsonRpcProvider(process.env.RPC_URL, undefined, { usePathing: true })
        const wallet = new quais.Wallet(process.env.CYPRUS1_PK, provider)
        console.log("👤 Deploying contracts with account:", wallet.address);

        // Deploy ERC20 Token
        console.log("\n1️⃣ Deploying ERC20 Token...");
        const MyTokenIpfsHash = await deployMetadata.pushMetadataToIPFS("MyToken")
        console.log(`📦 IPFS Hash for MyToken: ${MyTokenIpfsHash}`);
        
        const MyToken = new quais.ContractFactory(MyTokenJson.abi, MyTokenJson.bytecode, wallet, MyTokenIpfsHash)
        const name = process.env.ERC20_NAME || "MyToken";
        const symbol = process.env.ERC20_SYMBOL || "MTK";
        const totalSupply = quais.parseUnits(process.env.ERC20_INITIALSUPPLY || "1000000000000000000000000"); // 1 million tokens with 18 decimals
        const initialOwner = process.env.INITIAL_OWNER;

        console.log("\n📊 Token Parameters:");
        console.log(`📌 Name: ${name}`);
        console.log(`📌 Symbol: ${symbol}`);
        console.log(`📌 Total Supply: ${totalSupply.toString()}`);
        console.log(`📌 Initial Owner: ${initialOwner}`);

        const token = await MyToken.deploy(
            name,
            symbol,
            totalSupply,
            initialOwner
        );
        console.log('📝 Transaction broadcasted: ', token.deploymentTransaction().hash)
        await token.waitForDeployment();
        const tokenAddress = await token.getAddress()
        console.log(`✅ ERC20 Token deployed at: ${tokenAddress}`);

        // Verify Deployment
        console.log("\n2️⃣ Verifying Deployment...");
        const deployedName = await token.name();
        const deployedSymbol = await token.symbol();
        const deployedTotalSupply = await token.totalSupply();
        const deployedOwner = await token.owner();
        
        console.log("\n📊 Deployed Token Details:");
        console.log(`📌 Name: ${deployedName}`);
        console.log(`📌 Symbol: ${deployedSymbol}`);
        console.log(`📌 Total Supply: ${deployedTotalSupply.toString()}`);
        console.log(`📌 Owner: ${deployedOwner}`);

        // Deployment Summary
        console.log("\n🎉 Deployment Summary:");
        console.log(`📌 Token Address: ${tokenAddress}`);
        console.log(`📌 Token Name: ${deployedName}`);
        console.log(`📌 Token Symbol: ${deployedSymbol}`);
        console.log(`📌 Total Supply: ${deployedTotalSupply.toString()}`);
        console.log(`📌 Owner: ${deployedOwner}`);

    } catch (error) {
        console.error("❌ Deployment failed:", error);
        process.exit(1);
    }
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error("❌ Script failed:", error);
        process.exit(1);
    });

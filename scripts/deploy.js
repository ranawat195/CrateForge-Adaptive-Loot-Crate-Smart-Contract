const hre = require("hardhat");

async function main() {
  const cratePrice = hre.ethers.utils.parseEther("0.01");

  const CrateForge = await hre.ethers.getContractFactory("CrateForge");
  const crateForge = await CrateForge.deploy(cratePrice);

  await crateForge.deployed();
  console.log("CrateForge contract deployed to:", crateForge.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

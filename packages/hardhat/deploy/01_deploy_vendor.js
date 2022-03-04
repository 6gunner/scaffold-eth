module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const yourToken = await ethers.getContract("YourToken", deployer);
  console.log("\n 🤹  deployer = " + deployer + "\n");

  // Todo: deploy the vendor
  await deploy("Vendor", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    args: [yourToken.address],
    log: true,
  });
  const Vendor = await deployments.get("Vendor");
  const vendor = await ethers.getContract("Vendor", deployer);
  const balanceOfYourToken = await yourToken.balanceOf(deployer);
  console.log(`\n 🏵  Sending ${balanceOfYourToken} tokens to the vendor...\n`);
  const result = await yourToken.transfer(vendor.address, balanceOfYourToken);
  console.log("\n 🤹  Sending ownership to frontend address...\n");
  // ToDo: change address with your burner wallet address vvvv
  await vendor.transferOwnership("0x3C06b3691956496B6622aE8B75c6319164f22E78");
};

module.exports.tags = ["Vendor"];

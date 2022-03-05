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
  console.log("\n 🤹  Sending ownership to address...\n");
  // ToDo: change address with your burner wallet address vvvv
  // await vendor.transferOwnership("0x35D4A3Bd19382e5180824823E90312Be405c3707");
};

module.exports.tags = ["Vendor"];

const hre = require("hardhat");

async function main() {
  const Project = await hre.ethers.getContractFactory("Project");
  const project = await Project.deploy();

  await project.waitForDeployment();

  console.log("✅ Project deployed to:", await project.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });

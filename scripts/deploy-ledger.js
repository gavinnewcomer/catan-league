async function main() {    
    const [deployer] = await ethers.getSigners();
    console.log(
        "Deploying contracts with the account:",
        deployer.address
    );
    const CatanLeagueLedger = await ethers.getContractFactory("CatanLeagueLedger");
    const catanLeagueLedger = await CatanLeagueLedger.deploy()
    console.log("Contract Catan League Ledger deployed to address:", catanLeagueLedger.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });
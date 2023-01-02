async function main() {    
    const [deployer] = await ethers.getSigners();
    console.log(
        "Deploying contracts with the account:",
        deployer.address
    );
    const ledgerAddress = "0x2F78D7DCe7738523D56b9030Bbb5006dd64Beed7";
    const CatanLeagueLedger = await ethers.getContractFactory("CatanLeagueLedger");
    const catanLeagueLedger = await CatanLeagueLedger.attach(ledgerAddress)
    const mintTxn = await catanLeagueLedger.mintTrophy(100);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });
async function main() {    
    const [deployer] = await ethers.getSigners();
    console.log(
        "Deploying contracts with the account:",
        deployer.address
    );
    const ERC721T = await ethers.getContractFactory("ERC721T");
    const erc721T= await ERC721T.deploy()
    console.log("Contract ERC721T deployed to address:", erc721T.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });
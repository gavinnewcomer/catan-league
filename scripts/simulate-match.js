async function main() {    
    const [deployer] = await ethers.getSigners();
    console.log(
        "Deploying contracts with the account:",
        deployer.address
    );
    const DelegationContract = await ethers.getContractFactory("DelegationRegistryCloneFactory");
    const delegationContract = await DelegationContract.attach(
      deployedCloneFactoryAddress
    );
    const cloneTxn = await delegationContract.cloneRegistry(
        deployedDelegateAddress,
        "0x188b71C9d27cDeE01B9b0dfF5C1aff62E8D6F434",
        "0x326C977E6efc84E512bB9C30f76E30c160eD06FB",
        "0xd5df5b41a022d4fd77f3715f7e2b9e3be9ec2b20",
        "0xd5df5b41a022d4fd77f3715f7e2b9e3be9ec2b20",
        "https://giftynatewaychainlink.ngrok.io/delegated-address",
        bytes("4f9d27c9b0c84eed902d5bf09f3d8818")
    );
    console.log(cloneTxn);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });
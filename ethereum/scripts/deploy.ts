import fs from 'fs-extra';
import { ethers } from 'hardhat';
import { join } from 'path';

const buildPath = join(__dirname, '..', 'build');

const srcPath = join(__dirname, '..', 'artifacts', 'contracts', 'Campaign.sol');
// CampaignFactory.json;
// Campaign.json;

async function main() {
    // remove build folder
    fs.removeSync(buildPath);
    const Campaign = await ethers.getContractFactory('CampaignFactory');
    const campaignContract = await Campaign.deploy();

    await campaignContract.deployed();

    fs.ensureDirSync(buildPath);

    await Promise.all([
        fs.copyFile(
            join(srcPath, 'CampaignFactory.json'),
            join(buildPath, 'CampaignFactory.json'),
        ),
        fs.copyFile(
            join(srcPath, 'Campaign.json'),
            join(buildPath, 'Campaign.json'),
        ),
    ]);

    console.log('Transactions address: ', campaignContract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
};

runMain();

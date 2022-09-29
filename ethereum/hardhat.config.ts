import '@nomicfoundation/hardhat-toolbox';
import dotenv from 'dotenv';
import { HardhatUserConfig } from 'hardhat/config';
import { join } from 'path';

dotenv.config({ path: join(__dirname, '..', '.env') });

const { API_URL, PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
    solidity: '0.8.17',
    defaultNetwork: 'goerli',
    networks: {
        hardhat: {},
        goerli: {
            url: API_URL,
            accounts: [`0x${PRIVATE_KEY}`],
        },
    },
};

export default config;

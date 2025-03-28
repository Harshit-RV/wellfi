import { configDotenv } from 'dotenv';
import fs from 'fs';
import path from 'path';

configDotenv();

const credentialsPath = path.resolve('/tmp', 'credentials.json');
const googleApplicationCredentials = process.env.GOOGLE_APPLICATION_CREDENTIALS;

if (googleApplicationCredentials) {
    fs.writeFileSync(credentialsPath, googleApplicationCredentials, 'utf-8');
    process.env.GOOGLE_APPLICATION_CREDENTIALS = credentialsPath;
}

export default {
    mongoURI: process.env.MONGO_URI || '',
    plutofyApiKey: process.env.PLUTOFY_API_KEY || '',
    AWS_ACCESS_KEY_ID: process.env.AWS_ACCESS_KEY_ID || '',
    AWS_SECRET_ACCESS_KEY: process.env.AWS_SECRET_ACCESS_KEY || '',
    GOOGLE_APPLICATION_CREDENTIALS: process.env.GOOGLE_APPLICATION_CREDENTIALS || '',
};
import * as admin from "firebase-admin";
import config from './config';
import "dotenv/config";

admin.initializeApp({
  credential: admin.credential.cert(
    require(config.GOOGLE_APPLICATION_CREDENTIALS)
  ),
});

export default admin;
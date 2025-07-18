'use strict'
import crypto from 'crypto'

export const handler = async (event) => {
    console.log("starting execution of super important lambda");
    const responseValidPeriod = 300000; // 5 minutes - We should load this from env/parameter store
    const assetID = crypto.randomUUID();
    console.log("created asset id %s", assetID);
    return {
        statusCode: 200,
        body: JSON.stringify({
            assetID,
            validUntil: Date.now() + responseValidPeriod
        })
    };
};

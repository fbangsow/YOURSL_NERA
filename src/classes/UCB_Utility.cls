Public class UCB_Utility
{
    
    public static String generateRandomHashKey()
    {
        String hashKey = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob CryptoHash = Crypto.generateDigest('MD5', Blob.valueOf(hashKey));
        String hexDigestValue = EncodingUtil.convertToHex(CryptoHash);
        system.debug('hexDigestValue--->'+hexDigestValue);
        return hexDigestValue;
    }
    
}
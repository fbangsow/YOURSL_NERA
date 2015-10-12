/*
@Company: YOUR SL  
@Author: K. Verheyden
@Creation date: 14.04.2015  
@Ref: xxxxxxx
*/ 
public with sharing class UcbCrypto {
	
	private Integer  myKey = 128;

	public UcbCrypto() {
		
	}

	public Payload Encrypt(String input){

		Blob myGenerateKey = Crypto.generateAesKey(myKey);
		return new PayLoad(myGenerateKey,  Crypto.encryptWithManagedIV('AES128',myGenerateKey, Blob.valueOf(input)));
	}

	public String Decrypt(Blob encryptedData, Blob cryptoKey){

		Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey, encryptedData);
		return decryptedData.toString();
	}

	public class Payload{

		public Blob cryptoKey {get;set;}
		public Blob data {get;set;}

		public PayLoad(Blob ck, Blob d){

			this.cryptoKey = ck;
			this.data = d;
		}
	}
}
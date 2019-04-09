/*
 * Created by User on 05.04.2019.
 */
@IsTest
private with sharing class TestAccountTrigger {

	@IsTest
	static void testAccountShareWithoutTerritory() {
		Test.startTest();
		Account account = TestHelper.createAccountWithoutTerritory();
		Test.stopTest();
		User user = TestHelper.getSalerUserTest();
		List<AccountShare> accountShares = [
				SELECT Id
				FROM AccountShare
				WHERE UserOrGroupId = :user.Id
		AND AccountId = :account.Id
		];
		System.assertEquals(0, accountShares.size());
	}

	@IsTest
	static void testAccountShareAfterUpdate() {
		Test.startTest();
		Account account = TestHelper.createAccountWithoutTerritory();
		TerrUser__c terrUser = TestHelper.getTerrUser();
		Contact contact = TestHelper.createContact();
		Reference__c reference = new Reference__c();
		reference.Account__c = account.Id;
		reference.Contact__c = contact.Id;

		insert reference;

		account.Territory__c = terrUser.Territory__c;
		update account;

		Test.stopTest();

		List<AccountShare> accountShares2 = [
				SELECT Id
				FROM AccountShare
				WHERE UserOrGroupId = :terrUser.User__c
		AND AccountId = :account.Id
		];
		System.assertEquals(1, accountShares2.size());

	}

	@IsTest
	static void testDeleteAccount() {
		Test.startTest();
		TestHelper.getTerrUser();
		User user = TestHelper.getSalerUserTest();
		List<Account> accounts = TestHelper.createAccounts(3);
		List<AccountShare> accountShares3 = [
				SELECT Id
				FROM AccountShare
				WHERE UserOrGroupId = :user.Id
		AND AccountId IN :accounts
		];
		System.assertEquals(3, accountShares3.size());
		delete accounts;
		Test.stopTest();
		List<AccountShare> accountShares4 = [
				SELECT Id
				FROM AccountShare
				WHERE UserOrGroupId = :user.Id
		AND AccountId IN :accounts
		];
		System.assertEquals(0, accountShares4.size());

	}

	@isTest
	static void insertAccountWithtContactWithUser(){
		Test.startTest();
		Account account = TestHelper.createAccountWithoutTerritory();
		Contact contact = TestHelper.createContact();
		TerrUser__c terrUser = TestHelper.getTerrUser();
		Reference__c reference = new Reference__c();

		reference.Contact__c = contact.id;
		reference.Account__c = account.id;

		insert reference;

		account.Territory__c = terrUser.Territory__c;

		update account;

		delete reference;

		Test.stopTest();

		List<AccountShare> accountShares = [
				SELECT Id
				FROM AccountShare
				WHERE UserOrGroupId = :terrUser.User__c
		AND AccountId = :account.Id
		];
		System.assertEquals(1, accountShares.size(),'Account Share');

		List<ContactShare> contactShare = [
				SELECT Id
				FROM ContactShare
				WHERE UserOrGroupId = :terrUser.User__c
		AND ContactId = :contact.Id
		];
		System.assertEquals(0,contactShare.size(), 'Contact Share');


	}

}
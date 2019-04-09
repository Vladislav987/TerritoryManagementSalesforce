/*
 * Created by User on 05.04.2019.
 */
@IsTest
public with sharing class TestHelper {
	private static User user;
	private static Territory__c territory;

	public static List<Contact> createContacts(Integer numContacts) {
		List<Contact> contacts = new List<Contact>();
		for (Integer i = 0; i < numContacts; i++) {
			contacts.add(new Contact(LastName = 'Test Contact ' + i));
		}
		insert contacts;
		return contacts;
	}


	public static Account createAccountWithoutTerritory() {
		Account account = new Account(Name = 'Test Account Without Territory');
		insert account;
		return account;
	}

	public static User getSalerUserTest() {
		if (user == null) {
			Profile standardProf = [SELECT Id FROM Profile WHERE Name='Saler Manager'];
			user = new User(Alias = 'standt', Email='standarduser@testorg.com',
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
					LocaleSidKey='en_US', ProfileId = standardProf.Id,
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser7777@testorg.com');

			insert user;
		}
		return user;
	}

	public static TerrUser__c getTerrUser() {
		Territory__c territory = getTerritory();
		User user = getSalerUserTest();
		TerrUser__c terrUser = new TerrUser__c(
				Territory__c = territory.Id,
				User__c = user.Id
		);
		insert terrUser;
		return terrUser;
	}
	public static Territory__c getTerritory() {
		if (territory == null) {
			territory = new Territory__c(Name = 'Test Territory name');
			insert territory;
		}
		return territory;
	}

	public static List<Account> createAccounts(Integer numAccount) {
		List<Account> accounts = new List<Account>();
		Territory__c territory = getTerritory();
		for (Integer i = 0; i < numAccount; i++) {
			accounts.add(new Account(Name = ('Test Account ' + i), Territory__c = territory.Id));
		}
		insert accounts;
		return accounts;
	}

	public static List<Reference__c> createReferences(Integer numReferences) {
		List<Reference__c> references = new List<Reference__c>();
		for (Integer r = 0; r < numReferences; r++) {
			for (Account account : createAccounts(numReferences)) {
				for (Contact contact : createContacts(numReferences)) {
					references.add(new Reference__c(
							Account__c = account.Id,
							Contact__c = contact.Id
					));
				}
			}
		}
		insert references;
		return references;
	}

	public static Contact createContact() {
		Contact contact = new Contact(LastName = 'Test Contact Name');
		insert contact;
		return contact;
	}

}
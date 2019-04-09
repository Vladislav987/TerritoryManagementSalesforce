/*
 * Created by User on 05.04.2019.
 */
@IsTest
private with sharing class TestTerrUserTriger {
	@IsTest
	static void testCreateUTerrUser() {
		Test.startTest();
		List<Reference__c> references = TestHelper.createReferences(2);
		Set<Id> accountIds = new Set<Id>();
		Set<Id> contactIds = new Set<Id>();
		for (Reference__c reference : references) {
			accountIds.add(reference.Account__c);
			contactIds.add(reference.Contact__c);
		}
		TerrUser__c terrUser = TestHelper.getTerrUser();
		User user = TestHelper.getSalerUserTest();
		Territory__c territory = TestHelper.getTerritory();
		Test.stopTest();
		List<AccountShare> accountShares = [
				SELECT Id
				FROM AccountShare
				WHERE UserOrGroupId = :user.Id
		AND AccountId IN :accountIds
		];
		List<ContactShare> contactShares = [
				SELECT Id
				FROM ContactShare
				WHERE UserOrGroupId =:user.Id
		AND ContactId IN :contactIds
		];
		System.assertEquals(accountIds.size(), accountShares.size());

		System.assertEquals(contactIds.size(), contactShares.size());
	}

	@IsTest
	static void testUpdateTerrUser() {
		Test.startTest();
		List<Reference__c> references = TestHelper.createReferences(2);
		Set<Id> accountIds = new Set<Id>();
		Set<Id> contactIds = new Set<Id>();
		for (Reference__c reference : references) {
			accountIds.add(reference.Account__c);
			contactIds.add(reference.Contact__c);
		}
		TerrUser__c terrUser = TestHelper.getTerrUser();
		Territory__c territoryChild = new Territory__c(
				Name = 'Child name',
				ParentId__c = terrUser.Territory__c
		);

		insert territoryChild;
		terrUser.User__c = null;
		update terrUser;
		Test.stopTest();

		List<AccountShare> accountShares = [
				SELECT Id
				FROM AccountShare
				WHERE UserOrGroupId = :terrUser.User__c
		AND AccountId IN :accountIds
		];
		List<ContactShare> contactShares = [
				SELECT Id
				FROM ContactShare
				WHERE UserOrGroupId =:terrUser.User__c
		AND ContactId IN :contactIds
		];
		System.assertEquals(0, accountShares.size());

		System.assertEquals(0, contactShares.size());
	}

	@IsTest
	static void testDeleteTerrUser() {
		Test.startTest();
		List<Reference__c> references = TestHelper.createReferences(2);
		Set<Id> accountIds = new Set<Id>();
		Set<Id> contactIds = new Set<Id>();
		for (Reference__c reference : references) {
			accountIds.add(reference.Account__c);
			contactIds.add(reference.Contact__c);
		}
		TerrUser__c terrUser = TestHelper.getTerrUser();
		User user = TestHelper.getSalerUserTest();
		delete terrUser;
		Test.stopTest();
		List<AccountShare> accountShares = [
				SELECT Id
				FROM AccountShare
				WHERE UserOrGroupId = :user.Id
		AND AccountId IN :accountIds
		];
		List<ContactShare> contactShares = [
				SELECT Id
				FROM ContactShare
				WHERE UserOrGroupId =:user.Id
		AND ContactId IN :contactIds
		];
		System.assertEquals(0, accountShares.size());

		System.assertEquals(0, contactShares.size());
	}
}
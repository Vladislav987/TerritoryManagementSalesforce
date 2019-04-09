/*
 * Created by User on 05.04.2019.
 */
@IsTest
private with sharing class TestReferenceTrigger {
	@IsTest
	static void testCreateReference() {
		Test.startTest();
		List<Reference__c> references = TestHelper.createReferences(2);
		Test.stopTest();
		List<Reference__c> references2 = [
				SELECT Id
				FROM Reference__c
				WHERE Id IN :references
		];
		System.assertEquals(8, references2.size());
	}

	@IsTest
	static void testDeleteReference() {
		Test.startTest();
		List<Reference__c> references = TestHelper.createReferences(2);
		Test.stopTest();
		List<Reference__c> referencesInsert = [
				SELECT Id
				FROM Reference__c
				WHERE Id IN :references
		];
		System.assertEquals(8, referencesInsert.size());
		delete references;
		List<Reference__c> referencesDelete = [
				SELECT Id
				FROM Reference__c
				WHERE Id IN :references
		];

		System.assertEquals(0, referencesDelete.size());
	}
}
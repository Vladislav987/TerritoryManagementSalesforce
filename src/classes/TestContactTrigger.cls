/*
 * Created by User on 05.04.2019.
 */

@IsTest
private with sharing class TestContactTrigger {

	@IsTest
	 static void testCreateContact() {
		Test.startTest();
		List<Contact> contacts = TestHelper.createContacts(3);
		Test.stopTest();
		System.assertEquals(3, contacts.size());
		Contact contact = [
				SELECT AccountId
				FROM Contact
				WHERE Id IN :contacts
		LIMIT 1
		];
		System.assert(contact.AccountId != null);
	}
}

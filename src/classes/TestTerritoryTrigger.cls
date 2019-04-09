/*
 * Created by User on 06.04.2019.
 */
@IsTest
private with sharing class TestTerritoryTrigger {

	@isTest
	static void checkUnickName(){
		List<String> territoriesName = new List<String>();
		Territory__c parent = new Territory__c(Name = 'Test');
		territoriesName.add(parent.Name);
		Territory__c child1 = new Territory__c(Name = 'Test1');
		territoriesName.add(child1.Name);
		Territory__c child2 = new Territory__c(Name = 'Test2');
		territoriesName.add(child2.Name);
		Territory__c child3 = new Territory__c(Name = 'Test2');

		Test.startTest();
		insert parent;
		insert child1;
		insert child2;

		try{
			insert child3;
		}catch (dmlException e){
			System.debug(e);
		}

		Test.stopTest();

		List<Territory__c> territories = [SELECT Id
										  FROM Territory__c
										  WHERE Name IN :territoriesName
		];
		System.assertEquals(3, territories.size());

	}

	@isTest
	static void deleteTerritories(){
		Territory__c territory = TestHelper.getTerritory();

		Test.startTest();
		delete territory;
		Test.stopTest();
		List<Territory__c> territories= [SELECT Id
								FROM Territory__c
								WHERE Id = :territory.Id
		];
		System.assertEquals(0, territories.size());
	}

	@isTest
	static void updateTerritory(){
		Territory__c territory = TestHelper.getTerritory();
		Territory__c territoryParent = new Territory__c(Name ='Parent Territory');
		insert territoryParent;
		territory.ParentId__c = territoryParent.Id;
		territory.Name = 'new Test Name';
		Test.startTest();
		update territory;
		Test.stopTest();
	}

	@isTest
	static void changeUsers(){
		User salerUser = TestHelper.getSalerUserTest();
		Territory__c parentTerritory = new Territory__c(Name ='Parent test');
		insert parentTerritory;
		TerrUser__c terrUser = new TerrUser__c(User__c = salerUser.Id, Territory__c = parentTerritory.Id);
		Territory__c childTerritory = new Territory__c(Name = 'Child Test', ParentId__c = parentTerritory.Id);
		Account accountFirst = TestHelper.createAccountWithoutTerritory();
		Contact contactFirst = TestHelper.createContact();
		Reference__c reference = new Reference__c(Account__c =accountFirst.Id, Contact__c = contactFirst.Id);
		accountFirst.Territory__c = childTerritory.Id;


		Test.startTest();
		insert terrUser;
		insert childTerritory;
		insert reference;
		update accountFirst;

		Territory__c newTerritory = new Territory__c(Name = 'Country Test');
		insert newTerritory;

		User user = [SELECT Id FROM User WHERE Name = 'Taras Shevchenko'];
		TerrUser__c second = new TerrUser__c(Territory__c = newTerritory.Id, User__c = user.Id);
		childTerritory.ParentId__c = newTerritory.Id;

		insert second;
		update childTerritory;

		Test.stopTest();
		List<AccountShare> accountShareForSalerUser =[SELECT Id
														FROM AccountShare
														WHERE UserOrGroupId = :salerUser.Id
		];
		List<ContactShare> contactShareForSalerUser =[SELECT Id
														FROM ContactShare
														WHERE UserOrGroupId =:salerUser.Id
		];
		System.assertEquals(0, accountShareForSalerUser.size());
		System.assertEquals(0, contactShareForSalerUser.size());

		List<AccountShare> accountShareForUser =[SELECT Id
													FROM AccountShare
													WHERE UserOrGroupId = :user.Id
		];
		List<ContactShare> contactShareForUser =[SELECT Id
													FROM ContactShare
													WHERE UserOrGroupId = :user.Id
		];
		System.assertEquals(1, accountShareForUser.size(), '8888888');
		System.assertEquals(1, contactShareForUser.size(), '999999999');

	}

}
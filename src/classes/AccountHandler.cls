/*
 * Created by User on 01.04.2019.+
 */
public with sharing class AccountHandler {

	public static void insertAccountAndContactShares(List<Account> accounts) {
		List<AccountShare> accountShares = new List<AccountShare>();
		List<ContactShare> contactShare = new List<ContactShare>();
		List<Reference__c> accountReferences = new List<Reference__c>();
		Set<Id> accountsId = new Set<Id>();
		Map<Id, Set<Territory__c>> accountIdWithTerritories = new Map<Id, Set<Territory__c>>();

		for(Account account: accounts){
			accountsId.add(account.Id);
		}

		accountIdWithTerritories = TerritoryHelper.getTerritoriesWithParentsByAccount(accounts);
		accountShares = AccountHelper.getAccountSharesByAccountIdAndTerritories(accountIdWithTerritories);

		if (!accountShares.isEmpty()) {
			insert accountShares;
		}

		accountReferences = ReferenceHelper.getReferencesByAccountsId(accountsId);

		for (Id accountId : accountIdWithTerritories.keySet()) {
			for (Territory__c territories : accountIdWithTerritories.get(accountId)) {
				if (territories.TerrUsers__r != null) {
					for (TerrUser__c terrUser : territories.TerrUsers__r) {
						if(terrUser.User__c != null) {
							contactShare.addAll(ShareHelperForContacts.createContactsSharesByUsersIdAndReferences(terrUser.User__c, accountReferences));
						}
					}
				}
			}
		}

		if(!contactShare.isEmpty()){
			insert contactShare;
		}

	}

	public static void deleteContactSharesByAccounts(List<Account> accounts) {
		List<ContactShare> contactShares = new List<ContactShare>();
		Set<Id> contactsId = ContactHelper.getContactsIdByAccounts(accounts);

		contactShares = ShareHelperForContacts.getContactsSharesByContactsId(contactsId);

		if(!contactShares.isEmpty()){
			delete contactShares;
		}
	}

	public static void deleteOldSharesAndInsertNewShares(List<Account> newAccounts, Map<Id, Account> oldAccounts) {
		Map<Id, Account> accountsWithChangesTerritories = new Map<Id, Account>();
		Map<Id, Account> accountsWithOldTerritories = new Map<Id, Account>();

		for (Account account: newAccounts){
			if(account.Territory__c != oldAccounts.get(account.Id).Territory__c	){
				accountsWithOldTerritories.put(account.Id, account);
				if(account.Territory__c != null){
					accountsWithChangesTerritories.put(account.Id, account);
				}
			}
		}
		if(!accountsWithOldTerritories.isEmpty()){
			AccountHelper.deleteOldAccountContactShares(accountsWithOldTerritories);
		}

		insertAccountAndContactShares(accountsWithChangesTerritories.values());

	}
}
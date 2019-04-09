/*
 * Created by User on 28.03.2019.+
 */
public with sharing class AccountHelper {

	public static List<AccountShare> getAccountSharesByAccountIdAndTerritories(Map<Id, Set<Territory__c>> accountIdWithTerritories) {
		List<AccountShare> result = new List<AccountShare>();

		for (Id accountId : accountIdWithTerritories.keySet()) {
			for (Territory__c territories : accountIdWithTerritories.get(accountId)) {
				if (territories.TerrUsers__r != null) {
					for (TerrUser__c terrUser : territories.TerrUsers__r) {
						if(terrUser.User__c != null) {
							result.add(ShareHelperForAccounts.createAccountShareByUserIdAndAccountId(terrUser.User__c, accountId));
						}
					}
				}
			}
		}

		return result;
	}


	public static void deleteOldAccountContactShares(Map<Id,Account > oldAccounts){
		List<AccountShare> accountShare = new List<AccountShare>();

		accountShare = AccountHelper.getAccountSharesByAccount(oldAccounts.values());

		if(!accountShare.isEmpty()){
			delete accountShare;
		}

		AccountHandler.deleteContactSharesByAccounts(oldAccounts.values());
	}

	public static List<AccountShare> getAccountSharesByAccount(List<Account> accounts) {
		return [SELECT Id
				FROM AccountShare
				WHERE AccountId IN :accounts
		    	AND RowCause = 'Manual'
		];
	}

	public static Map<Id, Set<Id>> getAccountsIdWithUsersIdByAccountsId(Set<Id> accountsId) {
		Map<Id, Set<Id>> result = new Map<Id, Set<Id>>();

		List<AccountShare> accountShares= [SELECT Id,
		 											AccountId,
		 											UserOrGroupId
		 									FROM AccountShare
		 									WHERE AccountId IN : accountsId
											AND RowCause = 'Manual'
		];

		for(AccountShare elem: accountShares){
			if(result.containsKey(elem.AccountId)){
				result.get(elem.AccountId).add(elem.UserOrGroupId);
			}else{
				result.put(elem.AccountId, new Set<Id>{elem.UserOrGroupId});
			}
		}

		return result;
	}

	public static List<Account> getAccountsByTerritoriesId(Set<Id> territoriesId) {
		return [SELECT Id,
						Name,
			   (SELECT Id, Contact__c FROM Referenses__r)
				FROM Account
				WHERE Territory__c IN :territoriesId
		];
	}

	public static List<AccountShare> getAccountSharesByUsersIdAndAccounts(Map<Id, List<Account>> territoryWithAccounts,
																		  			Map<Id, Set<Id>> territoryIdWithUsersId) {
		List<AccountShare> result = new List<AccountShare>();
		List<AccountShare> accountShares = new List<AccountShare>();

		for(Id territoryId: territoryWithAccounts.keySet()){
			if(territoryIdWithUsersId.containsKey(territoryId)){
				accountShares = getSharesByUsersIdAndAccount(territoryWithAccounts.get(territoryId),
																		territoryIdWithUsersId.get(territoryId));
				result.addAll(accountShares);
			}
		}

		return result;
	}

	private static List<AccountShare> getSharesByUsersIdAndAccount(List<Account> accounts, Set<Id> usersId) {
		return [SELECT Id
				FROM AccountShare
				WHERE AccountId IN :accounts
				AND UserOrGroupId IN :usersId
				AND RowCause = 'Manual'
		];
	}

	public static List<AccountShare> createAccountSharesByAccountAndUsersId(Map<Id, List<Account>> territoryWithAccounts,
																			Map<Id, Set<Id>> territoryIdWithUsersId) {
		List<AccountShare> result = new List<AccountShare>();
		List<AccountShare> accountShare = new List<AccountShare>();

		for(Id territoryId: territoryWithAccounts.keySet()){
			if(territoryIdWithUsersId.containsKey(territoryId) ) {
				accountShare = createAccConShares(territoryWithAccounts.get(territoryId),
						territoryIdWithUsersId.get(territoryId));
				result.addAll(accountShare);
			}
		}

		return result;
	}

	private static List<AccountShare> createAccConShares(List<Account> accounts, Set<Id> usersId) {
		List<AccountShare> result = new List<AccountShare>();

		for(Account account: accounts){
			for(Id userId: usersId){
				result.add(ShareHelperForAccounts.createAccountShareByUserIdAndAccountId(userId, account.Id));
			}
		}

		return result;
	}
}
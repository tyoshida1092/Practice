global with sharing class TY_BatchExample_Batch
                    implements Database.Batchable<sObject>, Database.Stateful {
	global final Integer BATCH_SIZE = 100;
	global String param1;
	global Boolean isLastBatch = true;
	global Map<String,String> paramMap = new Map<String,String>{'Japanese' => '日本','English' => 'アメリカ'};

	global TY_BatchExample_Batch(String param1, Boolean isLastBatch){
		this.param1 = param1;
		this.isLastBatch = isLastBatch;
	}
	global Database.querylocator start(Database.BatchableContext BC){
		return Database.getQueryLocator('select id,Name from Contact where Languages__c=\'' + param1 + '\'');
	}
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		List<Contact> contacts = new List<Contact>();
		for(sObject s : scope){
			Contact cont = (Contact)s;
			cont.OtherCountry=paramMap.get(param1);
			contacts.add(cont);
		}
		update contacts;
	}
	global void finish(Database.BatchableContext BC){
		if(this.isLastBatch){
			sendFinishMail();
			return;
		}
    	param1 = 'English';
        TY_BatchExample_Batch testBatch = new TY_BatchExample_Batch(param1,true);
        Database.executeBatch(testBatch, BATCH_SIZE);
	}
	private void sendFinishMail(){
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {'tyoshida@appirio.com'};
		mail.setToAddresses(toAddresses);
		mail.setSubject('バッチ処理完了');
		mail.setPlainTextBody('バッチ処理が完了しました。\n' + system.now());
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
}
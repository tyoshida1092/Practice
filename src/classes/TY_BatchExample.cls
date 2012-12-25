public with sharing class TY_BatchExample {
	private final Integer BATCH_SIZE = 100;
    public PageReference execute() {
    	String param1 = 'Japanese';
        TY_BatchExample_Batch testBatch = new TY_BatchExample_Batch(param1,false);
        Database.executeBatch(testBatch, BATCH_SIZE);
        return null;
    }
}
public with sharing class BGE_HandsOnGridSelector {

    public static final Integer SQL_MINOR_LIMIT = 1;
    public static final Integer SQL_MAJOR_LIMIT = 10000;

    public Map<Id, Batch_Template_Field__c> getTemplateFieldsByTemplateId(Id recordId) {

        Map<Id, Batch_Template_Field__c> result = new Map<Id, Batch_Template_Field__c>([SELECT
                                                                                            Name,
                                                                                            Order__c,
                                                                                            Read_Only__c,
                                                                                            Required__c
                                                                                        FROM Batch_Template_Field__c
                                                                                        WHERE Batch_Template__c =: recordId
                                                                                        ORDER BY Order__c ASC
                                                                                        LIMIT :SQL_MAJOR_LIMIT]);
        return result;
    }

    public SObject[] getDataImportsByBatchId(Id recordId, String[] fieldNames) {

        return getDataImportsByBatchId(recordId, fieldNames, 0);
    }

    public SObject[] getDataImportsByBatchId(Id recordId, String[] fieldNames, Integer offset) {

        String query = 'SELECT ';
        query += String.join(fieldNames, ',');
        query += ' FROM DataImport__c WHERE NPSP_Data_Import_Batch__c = :recordId ORDER BY createdDate ASC LIMIT 50 OFFSET :offset';

        return Database.query(query);
    }

    public DataImport__c getDataImportForDryRunByBatchId(Id recordId) {

        String[] fieldNames = getAllFields(recordId);

        DataImport__c[] result = (DataImport__c[]) getGenericQueryRecordById(recordId, fieldNames);

        return !result.isEmpty() ? result[0] : null;
    }

    public DataImportBatch__c getBatchById(Id recordId) {

        DataImportBatch__c[] result = new DataImportBatch__c[] {};

        result = [SELECT
                        Batch_Template__c,
                        Account_Custom_Unique_ID__c,
                        Batch_Process_Size__c,
                        Contact_Custom_Unique_ID__c,
                        Contact_Matching_Rule__c,
                        Donation_Matching_Behavior__c,
                        Donation_Matching_Implementing_Class__c,
                        Donation_Matching_Rule__c,
                        Donation_Date_Range__c,
                        Run_Opportunity_Rollups_while_Processing__c,
                        Post_Process_Implementing_Class__c
                    FROM DataImportBatch__c
                    WHERE Id = :recordId LIMIT :SQL_MINOR_LIMIT];

        return !result.isEmpty() ? result[0] : null;
    }

    public void deleteRowsById(Set<Id> recordIds) {

        delete [SELECT Id FROM DataImport__c WHERE Id IN :recordIds];

    }

    public Integer getDataImportBatchCountByBatchId(Id recordId) {

        Integer result = 0;

        try {
            result = [SELECT count() FROM DataImport__c WHERE NPSP_Data_Import_Batch__c = :recordId];
        }
        catch (DmlException ex) {
            result = 0;
        }

        return result;
    }

    public Decimal getDataImportDonationAmountByBatchId(String recordId) {

        Decimal result = 0;

        AggregateResult[] query = [SELECT SUM(Donation_Amount__c)
                                    FROM DataImport__c
                                    WHERE NPSP_Data_Import_Batch__c = :recordId
                                    AND Donation_Amount__c != null];

        if (!query.isEmpty()) {
            result = (Decimal) query[0].get('expr0') != null ? (Decimal) query[0].get('expr0') : 0;
        }

        return result;
    }

    private static String[] getAllFields(Id id) {

        Schema.DescribeSObjectResult objectType = id.getSobjectType().getDescribe();
        Map<String,Schema.SObjectField> recordFields = objectType.fields.getMap();

        String[] result = new String[] {};

        for (Schema.SObjectField recordField :recordFields.values()) {

            if (recordField.getDescribe().isAccessible()) {
                result.add(recordField.getDescribe().getName());
            }
        }

        return result;
    }

    private static SObject[] getGenericQueryRecordById(Id id, String[] recordFields) {

        String query = 'SELECT ' + String.join(recordFields, ',') +
                        ' FROM ' + id.getSobjectType().getDescribe().getName() +
                        ' WHERE Id = :id';

        return Database.query(query);
    }


	public static Map<String, String> getObjectRecordTypesById(String objectName) {

        Map<String, String> result = new Map<String, String>();

        Map<String, Schema.RecordTypeInfo> recordTypes = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName();

        for (Schema.RecordTypeInfo recordType :recordTypes.values()) {

            result.put(recordType.getRecordTypeId(), recordType.getName());
        }

        return result;
    }

}
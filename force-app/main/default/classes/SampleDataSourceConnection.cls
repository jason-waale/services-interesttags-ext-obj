/**
 * Reference Implementtion from Salesforce docs
 * https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_DataSource_Connection.htm?q=Connection%20Class
 */

global class SampleDataSourceConnection extends DataSource.Connection {
    global SampleDataSourceConnection(DataSource.ConnectionParams connectionParams) {
    }
    
    private static final String COLUMN_NAME_NAME = 'Name';
    private static final String COLUMN_NAME_EXTERNAL_ID = 'ExternalId';
    private static final String COLUMN_NAME_DISPLAY_URL = 'DisplayUrl';
    private static final String COLUMN_NAME_CLIENT_ID = 'ClientId';


    /**
     * Validate and sync button in the Setup UI
     * TODO: Include categories
     */
    override global List<DataSource.Table> sync() {
        logWarning('STARTING SYNC');
        System.debug('STARTING SYNC');
        
        List<DataSource.Table> tables = new List<DataSource.Table>();        
        List<DataSource.Column> columns;
        columns = new List<DataSource.Column>();
        columns.add(DataSource.Column.text(COLUMN_NAME_NAME, 255));
        columns.add(DataSource.Column.text('COLUMN_NAME_EXTERNAL_ID', 255)); 
        columns.add(DataSource.Column.url('COLUMN_NAME_DISPLAY_URL')); // Needed for Adapter to work
        columns.add(DataSource.Column.text('COLUMN_NAME_CLIENT_ID', 18));
        
        tables.add(DataSource.Table.get('InterestTagReport', 'Name', columns));

        return tables;
    }
    
    override global DataSource.TableResult query(DataSource.QueryContext c) {
        return DataSource.TableResult.get(c, DataSource.QueryUtils.process(c, getRows()));
    }


     /**
      * Helper method to get record values from the external system for the Sample table.
      * TODO: 
      *   1) Switch from Topics to InterestTags
      *   2) Include categories 
      *   3) Optimize for performance as this could hit limits. Best to filter Clients in the Report before using Topic filter
      */
     private List<Map<String, Object>> getRows () {
        System.debug('Entering getRows method');

        // Initialize rows list
        List<Map<String, Object>> rows = new List<Map<String, Object>>();

        // Query TopicAssignment for records where EntityType = 'Account'
        // TODO: Check which column is indexed. EntityTypePrefix may be faster.
        List<TopicAssignment> topicAssignments = [
            SELECT Id, EntityId, TopicId 
            FROM TopicAssignment 
            WHERE EntityType = 'Account'
        ];
        System.debug('TopicAssignments retrieved: ' + topicAssignments);


        // Get TopicId values
        Set<Id> topicIds = new Set<Id>();
        for (TopicAssignment ta : topicAssignments) {
            topicIds.add(ta.TopicId);
        }
        System.debug('TopicIds collected: ' + topicIds);
        

        // Query Topic for Topic.Name values
        Map<Id, String> topicNames = new Map<Id, String>();
        for (Topic t : [SELECT Id, Name FROM Topic WHERE Id IN :topicIds]) {
            topicNames.put(t.Id, t.Name);
        }
        System.debug('Topic names retrieved: ' + topicNames);

        // Add results to rows
        for (TopicAssignment ta : topicAssignments) {
            Map<String, Object> row = new Map<String, Object>();
            row.put(COLUMN_NAME_NAME, String.valueOf(topicNames.get(ta.TopicId)));
            row.put(COLUMN_NAME_EXTERNAL_ID, String.valueOf(ta.EntityId));
            row.put(COLUMN_NAME_CLIENT_ID, String.valueOf(ta.EntityId));
            rows.add(row);
        }

        // Return rows
        System.debug('Exiting getRows method with rows: ' + rows);
        return rows;
    }


    // Helper method to get record values from the external system for the Sample table.

    // private List<Map<String, Object>> getRowsOrigional () {
    //     // Get row field values for the Sample table from the external system via a callout.
    //     HttpResponse response = makeGetCallout();
    //     // Parse the JSON response and populate the rows.
    //     Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(
    //             response.getBody());
    //     Map<String, Object> error = (Map<String, Object>)m.get('error');
    //     if (error != null) {
    //         throwException(string.valueOf(error.get('message')));
    //     }
    //     List<Map<String,Object>> rows = new List<Map<String,Object>>();
    //     List<Object> jsonRows = (List<Object>)m.get('value');
    //     if (jsonRows == null) {
    //         rows.add(foundRow(m));
    //     } else {
    //         for (Object jsonRow : jsonRows) {
    //             Map<String,Object> row = (Map<String,Object>)jsonRow;
    //             rows.add(foundRow(row));
    //         }
    //     }
    //     return rows;
    // }
    

     
    //  // Populate a row based on values from the external system.
    //  private Map<String,Object> foundRow(Map<String,Object> foundRow) {
    //     Map<String,Object> row = new Map<String,Object>();
    //     row.put('ExternalId', string.valueOf(foundRow.get('Id')));
    //     row.put('DisplayUrl', string.valueOf(foundRow.get('DisplayUrl')));
    //     row.put('Name', string.valueOf(foundRow.get('Name')));        
    //     return row;
    // }

     
}
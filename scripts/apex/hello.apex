// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

 List<TopicAssignment> topicAssignments = [
            SELECT Id, EntityId, TopicId 
            FROM TopicAssignment 
            WHERE EntityType = 'Account'
        ];
        System.debug('TopicAssignments retrieved: ' + topicAssignments);
        System.debug('Total TopicAssignments retrieved: ' + topicAssignments.size());

for (TopicAssignment ta : topicAssignments) {
    String clientName = [SELECT Name FROM Account WHERE Id = :ta.EntityId].Name;
    String topicName = [SELECT Name FROM Topic WHERE Id = :ta.TopicId].Name;
    System.debug('TopicAssignment Id: ' + ta.Id);
    System.debug('TopicName: ' + topicName);
    System.debug('ClientName: ' + clientName);    
    System.debug('*************************************');    
    System.debug('*************************************');    
}
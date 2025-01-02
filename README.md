# FSC InterestTags as an External Object POC

Uses a SF Connect Custom Adaptor to create an external object on Interest Tags so it can be used with Standard Reports

## SETUP
1. Deploy to an org that has both a SF Connect Licenese and an FSC License
2. Setup Interest Tags
3. Add SF Connect Data Source (Custom)
4. Add External Object
   * Ensure reporting is enabled
5. Change the ClientId field to a Lookup field relating to Account
6. Create a Custom Report Type with Accounts and Interest Tags

## USEFUL LINKS
- [Apex Connector Framework Getting Started](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_connector_start.htm)
- [Connection Class](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_DataSource_Connection.htm?q=Connection%20Class)
- [External Object Relationships](https://help.salesforce.com/s/articleView?id=platform.external_object_relationships.htm&type=5)
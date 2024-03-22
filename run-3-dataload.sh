#!/bin/sh
sf data upsert bulk --sobject MetadataFile__c --file transform/out/1_MetadataFile__c.csv --external-id ExternalId__c --json --wait 3
sf data upsert bulk --sobject RuleSetResult__c --file transform/out/2_RuleSetResult__c.csv --external-id ExternalId__c --json --wait 3
sf data upsert bulk --sobject RuleResult__c --file transform/out/3_RuleResult__c.csv --external-id ExternalId__c --json --wait 3
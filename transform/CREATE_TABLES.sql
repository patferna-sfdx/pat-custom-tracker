DROP TABLE IF EXISTS PmdReport;
CREATE TABLE "PmdReport" (
    "Problem" TEXT,
    "Package" TEXT,
    "File" TEXT,
    "Priority" TEXT,
    "Line" TEXT,
    "Description" TEXT,
    "Rule set" TEXT,
    "Rule" TEXT
);

DROP TABLE IF EXISTS MetadataFile__c;
CREATE TABLE "MetadataFile__c" (
    "Name" TEXT,
    "ExternalId__c" TEXT,
    "Type__c" TEXT
);

DROP TABLE IF EXISTS RuleSetResult__c;
CREATE TABLE "RuleSetResult__c" (
    "ExternalId__c" TEXT,
    "ReportDate__c" TEXT,
    "MetadataFile__r.ExternalId__c" TEXT,
    "Type__c" TEXT
);

DROP TABLE IF EXISTS RuleResult__c;
CREATE TABLE "RuleResult__c" (
    "RuleSetResult__r.ExternalId__c" TEXT,
    "ExternalId__c" TEXT,
    "Problem__c" TEXT,
    "Line__c" TEXT,
    "Description__c" TEXT,
    "Name" TEXT,
    "MetadataFile__r.ExternalId__c" TEXT,
    "Priority__c" TEXT
);









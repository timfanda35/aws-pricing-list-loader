Base URL: https://pricing.us-east-1.amazonaws.com

# How To
- [How to read the AWS Service index file](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/bulk-api-reading-price-list-files.html)
- [How to read Service Region index file for an AWS service](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/service-region-index-file-for-service.html)
- [How to read Service Region index file for Savings Plan](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/service-region-index-files-for-savings-plan.html)
- [How to read service price list file for an AWS service](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/reading-service-price-list-file-for-services.html)
- [How to read service price list file for a Savings Plan](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/reading-service-price-list-file-for-savings-plans.html)

# Get Service Region index file for an AWS service

json path: `.offers[].currentRegionIndexUrl` to get the service price list file for an AWS service

```json
{
  "formatVersion" : "v1.0",
  "disclaimer" : "This pricing list is for informational purposes only. All prices are subject to the additional terms included in the pricing pages on http://aws.amazon.com. All Free Tier prices are also subject to the terms included at https://aws.amazon.com/free/",
  "publicationDate" : "2026-04-27T07:13:25Z",
  "offers" : {
    "comprehend" : {
      "offerCode" : "comprehend",
      "versionIndexUrl" : "/offers/v1.0/aws/comprehend/index.json",
      "currentVersionUrl" : "/offers/v1.0/aws/comprehend/current/index.json",
      "currentRegionIndexUrl" : "/offers/v1.0/aws/comprehend/current/region_index.json"
    },
```

## Get service price list file for an AWS service

json path: `.publicationDate` to check it is the latest version

json path: `.regions[].currentVersionUrl`

We change the ext name from `.json` to `.csv` to get the service pricing list

```json
{
  "formatVersion" : "v1.0",
  "disclaimer" : "This pricing list is for informational purposes only. All prices are subject to the additional terms included in the pricing pages on http://aws.amazon.com. All Free Tier prices are also subject to the terms included at https://aws.amazon.com/free/",
  "publicationDate" : "2026-01-16T16:02:58Z",
  "regions" : {
    "ap-south-1" : {
      "regionCode" : "ap-south-1",
      "currentVersionUrl" : "/offers/v1.0/aws/comprehend/20260116160258/ap-south-1/index.json"
    },
```

## Service Pricing list file sample

The first 6 lines are:

```csv
"FormatVersion","v1.0"
"Disclaimer","This pricing list is for informational purposes only. All prices are subject to the additional terms included in the pricing pages on http://aws.amazon.com. All Free Tier prices are also subject to the terms included at https://aws.amazon.com/free/"
"Publication Date","2026-01-16T16:02:58Z"
"Version","20260116160258"
"OfferCode","comprehend"
"SKU","OfferTermCode","RateCode","TermType","PriceDescription","EffectiveDate","StartingRange","EndingRange","Unit","PricePerUnit","Currency","Product Family","serviceCode","Location","Location Type","Group","Group Description","usageType","operation","PlatoFeatureType","Region Code","serviceName"
```

We can use the line 6 to create table schema.

After remove the first 6 lines, we can use the `COPY_FROM` to load data to the Postgres Table.

Different AWS service should be the different data table.

# Get Service Region index file for Savings Plan
There are only three Service Region index files, we don't need to find them in the AWS Service index file:
|Savings Plan|Service Region index file Path|
| --- | --- |
| AWSDatabaseSavingsPlans | /savingsPlan/v1.0/aws/AWSDatabaseSavingsPlans/current/region_index.json |
| AWSMachineLearningSavingsPlans | /savingsPlan/v1.0/aws/AWSMachineLearningSavingsPlans/current/region_index.json |
| AWSComputeSavingsPlan | /savingsPlan/v1.0/aws/AWSComputeSavingsPlan/current/region_index.json |

json path: `.publicationDate` to check it is the latest version

json path: `.regions[].versionUrl` to get the service price list file for a Savings Plan

We change the ext name from `.json` to `.csv` to get the service pricing list

```json
{
  "disclaimer" : "This pricing list is for informational purposes only. All prices are subject to the additional terms included in the pricing pages on http://aws.amazon.com. All Free Tier prices are also subject to the terms included at https://aws.amazon.com/free/",
  "publicationDate" : "2026-04-22T19:42:03Z",
  "regions" : [ {
    "regionCode" : "ap-south-2",
    "versionUrl" : "/savingsPlan/v1.0/aws/AWSDatabaseSavingsPlans/20260422194203/ap-south-2/index.json"
  }
```

## Savings Plan Pricing list file sample


```csv
FormatVersion,v1.0
Disclaimer,This pricing list is for informational purposes only. All prices are subject to the additional terms included in the pricing pages on http://aws.amazon.com. All Free Tier prices are also subject to the terms included at https://aws.amazon.com/free/
Publication Date,2026-04-22T19:42:03Z
Version,20260422194203
OfferCode,AmazonDatabaseSavingsPlans
SKU,RateCode,Unit,EffectiveDate,DiscountedRate,Currency,DiscountedSKU,DiscountedServiceCode,DiscountedUsageType,DiscountedOperation,PurchaseOption,LeaseContractLength,LeaseContractLengthUnit,ServiceCode,UsageType,Operation,Description,Instance Family,Location,Location Type,Granularity,Product Family,DiscountedRegionCode,DiscountedInstanceType
```

We can use the line 6 to create table schema.

After remove the first 6 lines, we can use the `COPY_FROM` to load data to the Postgres Table.

Different SavingsPlan should be the different data table.

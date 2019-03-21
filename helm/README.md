# Object Storage Service (ECS)

[ Elastic Cloud Storage (ECS) ](https://www.emc.com/techpubs/api/ecs/v2-0-0-0/index.htm)provides a complete software-defined cloud storage platform that supports the storage, manipulation, and analysis of unstructured data on a massive scale on commodity hardware.


## Introduction

This chart gives you the opportunity to create a bucket on ecs, it can be accessed as a bucket s3 or as a bucket swift  (in Alpha for the moment), according to the configuration of your release.

Once the chart is created you will get a release of this chart containing all the infos to login or desciption of errors if any.

To delete the bucket you just have to empty the bucket and them delete the release.
### ( DO NOT DELETE A BUCKET VIA THE SDK OR THE API, MANDATORY PROCESS IS TO DELETE THE RELEASE WHICH WILL DELETE THE BUCKET )


## Configuration

The following table lists the configurable parameters of the ECS chart and their default values.

| Parameter                                  | Description                                                                                                    | Default                              |
|--------------------------------------------|----------------------------------------------------------------------------------------------------------------|--------------------------------------|
| `Release.Name`                           | Name of the realease on ICP (Must be unique on the cluster) | `None`                                          |
| `Target.Namespace`                         | The name of the namespace kubernetes where login informations be stored                                                                                               | `None`                                      |
| `Service.Name`                                | A string of 1 to 3 characters defining your application. It will be used for the name of your user and your bucket                                                                                                | `None` |
| `Secret.Key` |S3 This String will be the Secret Key of your bucket in base64, Swift: this string will be your password in base64| `None`|
| `Storage.type`|This is the type of the bucket that you want to create | `S3`  |
| `CodeAp` | This is your CodeAP (ap*****) should be in lowercase| `None`|
| `Bucket size` | This is the quota apply on your bucket, a soft limit will be set based on the hard one | `None`|
> **Tip**: The name of your User / bucket will be generated with your Service Name + CodeAP + nomenclature and must be unique, you will have some errors if you try to create a bucket that already exist.
> **Tip**: Pay attention, these parameters are set during provisinong of the release only.

# Quota
When you chose the bucket size, it's define your hard quota, but you will also have a soft quota apply depanding of the size you have chosen for the hard quota.
|Hard quota  | Soft quota |
|--|--|
| 3 GB | 2 GB |
| 5 GB | 4 GB |
| 10 GB | 8 GB |
| 25 GB | 20 GB |
| 50 GB | 40 GB |
| 100 GB | 80 GB |
| 250 GB | 200 GB |
| 500 GB | 400 GB |
| 1000 GB | 800 GB |



# How to use the service
You can create a release of this chart by clicking on the button "configure" right below.

Creating a release will launch a job that will take care of creating your Bucket / User.

Once this operation is done, it will create a secret (kubernetes) inside the namespace you have chosen, in this secret you will find different information encode in Base64, you will have to decode them to read them.

> **Tip**: the secret take the name of the release + the name of the Chart.


| Parameter | Description |
|--------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| `Bucket.Name`                           | The name of your Bucket
| `Namespace.ecs`                         | The namespace where your Bucket is Create|
| `Secretkey`                             | If you use S3, this will be your secret key, else if you use Swift, this will be your password.|
| `ecs-username`                          | The username of your new user|
| `ecs-status`                            | The status of your request request (ok/ko)|
| `ecsresponse`                           | The content of the response of your request (in case of error you should look right here!)|
| `ecs-host-s3`                           | The host URL for buckets in S3 |
| `ecs-host-swift`                        | The host URL for buckets in Swift |



# Connections
The connection to your bucket will depend of the type of this bucket.
You can find the complet documentation here : https://www.emc.com/techpubs/api/ecs/v2-0-0-0/index.htm

## Hosts
- The host for S3 is : ecss3-dc1.staging.echonet
- The host for swift is : ecsswift-dc1.staging.echonet
- The port is 443

## Authenticating with the S3 service

Authenticating with the Amazon S3 API is described in the Amazon S3 documentation referenced below. This topic identifies any ECS-specific aspects of the authentication process.

Amazon S3 uses an authorization header that must be present in all requests to identify the user and provide a signature for the request. When calling Amazon the header has the following format:

Authorization: AWS <AWSAccessKeyId>:<Signature>

In ECS, the AWSAccessKeyId maps to the ECS user id (UID). An AWS access key ID has 20 characters (some S3 clients, such as the S3 Browser, check this), but ECS data service does not have this limitation.

The signature is calculated from elements of the request and the user's Secret Key as detailed in the Amazon S3 documentation:

-   [http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html](http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html)

The following notes apply:

-   In the ECS object data service, the UID can be configured (through the ECS API or the ECS UI) with 2 secret keys. The ECS data service will try to use the first secret key, and if the calculated signature does not match, it will try to use the second secret key. If the second key fails, it will reject the request. When users add or change the secret key, they should wait 2 minutes so that all data service nodes can be refreshed with the new secret key before using the new secret key.
-   In the ECS data service, namespace is also taken into HMAC signature calculation.



## Using SDKs to access the S3 service

When developing applications that talk to the ECS S3 service, there are a number of SDKs that will support your development activity, **but we only support the Amazon SDK**.

The following topics describe the use of the Amazon S3 SDK.

-   [Using the Java Amazon SDK](https://www.emc.com/techpubs/ecs/ecs_s3_supported_features-1.htm#GUID-149BE134-6938-4CD7-9503-CF3CA9D23261 "You can access ECS object storage using the Java S3 SDK.")



### Using the Java Amazon SDK

You can access ECS object storage using the Java S3 SDK.

By default the AmazonS3Client client object is coded to work directly against amazon.com. This section shows how to set up the AmazonS3Client to work against ECS.

In order to create an instance of the AmazonS3Client object, you need to pass it credentials. This is achieved through creating an AWSCredentials object and passing it the AWS Access Key (your ECS username) and your generated secret key for ECS.

The following code snippet shows how to set this up.

AmazonS3Client client = new AmazonS3Client(new BasicAWSCredentials(uid, secret));

By default the Amazon client will attempt to contact Amazon WebServices. In order to override this behavior and contact ECS you need to set a specific endpoint.

You can set the endpoint using the setEndpoint method. The protocol specified on the endpoint dictates whether the client should be directed at the HTTP port (9020) or the HTTPS port (9021).

> Note: If you intend to use the HTTPS port, the JDK of your application
> must be set up to validate the ECS certificate successfully; otherwise
> the client will throw SSL verification errors and fail to connect.



In the snippet below, the client is being used to access ECS over HTTP:

AmazonS3Client client = new AmazonS3Client(new BasicAWSCredentials(uid, secret));
client.setEndpoint("http://ecs1.emc.com:9020");

When using path-style addressing ( ecs1.emc.com/mybucket ), you will need to set the setPathStyleAccess option, as shown below:

        S3ClientOptions options = new S3ClientOptions();
        options.setPathStyleAccess(true);

        AmazonS3Client client = new AmazonS3Client(new BasicAWSCredentials(uid, secret));
        client.setEndpoint("http://ecs1.emc.com:9020");
        client.setS3ClientOptions(options);

        The following code shows how to list objects in a bucket.

        ObjectListing objects = client.listObjects("mybucket");
        for (S3ObjectSummary summary : objects.getObjectSummaries()) {
            System.out.println(summary.getKey()+ "   "+summary.getOwner());
        }

The CreateBucket operation differs from other operations in that it expects a region to be specified. Against S3 this would indicate the datacenter in which the bucket should be created. However, ECS does not support regions. For this reason, when calling the CreateBucket operation, we specify the standard region, which stops the AWS client from downloading the Amazon Region configuration file from Amazon CloudFront.

client.createBucket("mybucket", "Standard");

The complete example for communicating with the ECS S3 data service, creating a bucket, and then manipulating an object is provided below:

        public class Test {
            public static String uid = "root";
            public static String secret = "KHBkaH0Xd7YKF43ZPFbWMBT9OP0vIcFAMkD/9dwj";
            public static String viprDataNode = "http://ecs.yourco.com:9020";

            public static String bucketName = "myBucket";
            public static File objectFile = new File("/photos/cat1.jpg");

            public static void main(String[] args) throws Exception {

                AmazonS3Client client = new AmazonS3Client(new BasicAWSCredentials(uid, secret));

                S3ClientOptions options = new S3ClientOptions();
                options.setPathStyleAccess(true);

                AmazonS3Client client = new AmazonS3Client(credentials);
                client.setEndpoint(viprDataNode);
                client.setS3ClientOptions(options);

                client.createBucket(bucketName, "Standard");
                listObjects(client);

                client.putObject(bucketName, objectFile.getName(), objectFile);
                listObjects(client);

                client.copyObject(bucketName,objectFile.getName(),bucketName, "copy-" + objectFile.getName());
                listObjects(client);
            }

    public static void listObjects(AmazonS3Client client) {
        ObjectListing objects = client.listObjects(bucketName);
        for (S3ObjectSummary summary : objects.getObjectSummaries()) {
            System.out.println(summary.getKey()+ "   "+summary.getOwner());
        }
    }



# ( Alpha version ) Authenticating with the Swift service

## Procedure OpenStack Version 1 authentication

Call the OpenStack authentication REST API shown below. Use port 9024 for HTTP, or port 9025 for HTTPS.

    Request:

            GET /auth/v1.0
              X-Auth-User: myUser@emc.com
              X-Auth-Key: myPassword

    Response:

            HTTP/1.1
               204 No
               Content
               Date: Mon, 12 Nov 2010 15:32:21 GMT
               Server: Apache

               X-Storage-Url: https://{hostname}/v1/account
               X-Auth-Token: eaaafd18-0fed-4b3a-81b4-663c99ec1cbb
               Content-Length: 0


### Results

If the UID and password are validated by ECS, the storage URL and token are returned in the response header. Further requests are authenticated by including this token. The storage URL provides the host name and resource address. You can access containers and objects by providing the following X-Storage-Url header:

X-Storage-Url: https://{hostname}/v1/{account}/{container}/{object}

The generated token expires 24 hours after creation. If you repeat the authentication request within the 24 hour period using the same UID and password, OpenStack will return the same token. Once the 24 hour expiration period expires, OpenStack will return a new token.

### Example

In the following simple authentication example, the first REST call returns an X-Auth-Token. The second REST call uses that X-Auth-Token to perform a GET request on an account.

        $ curl -i -H "X-Storage-User: tim_250@sanity.local" -H "X-Storage-Pass: 1fO9X3xyrVhfcokqy3U1UyTY029gha5T+k+vjLqS"
                                                                                   http://ecs.yourco.com:9024/auth/v1.0

         HTTP/1.1 204 No Content
            X-Storage-Url: http://ecs.yourco.com:9024/v1/s3
            X-Auth-Token: 8cf4a4e943f94711aad1c91a08e98435
            Server: Jetty(7.6.4.v20120524)

        $ curl -v -X GET -s -H "X-Auth-Token: 8cf4a4e943f94711aad1c91a08e98435"
                                                              http://ecs.yourco.com:9024/v1/s3

* About to connect() to ecs.yourco.com port 9024 (#0)
    * Trying 203.0.113.10...
    * Adding handle: conn: 0x7f9218808c00
    * Adding handle: send: 0
    * Adding handle: recv: 0
    * Curl_addHandleToPipeline: length: 1
    * - Conn 0 (0x7f9218808c00) send_pipe: 1, recv_pipe: 0
    * Connected to ecs.yourco.com (203.0.113.10) port 9024 (#0)

    > GET /v1/s3 HTTP/1.1
    > User-Agent: curl/7.31.0
    > Host: ecs.yourco.com:9024
    > Accept: */*
    > X-Auth-Token: 8cf4a4e943f94711aad1c91a08e98435
    >
    < HTTP/1.1 204 No Content
    < Date: Mon, 16 Sep 2013 19:31:45 GMT
    < Content-Type: text/plain
    * Server Jetty(7.6.4.v20120524) is not blacklisted
    < Server: Jetty(7.6.4.v20120524)


    * Connection #0 to host ecs.yourco.com left intact


### Procedure OpenStack Version 2 authentication

ECS includes limited support for OpenStack Version 2 (Keystone) authentication.

### Before you begin

OpenStack V2 introduces unscoped tokens. These can be used to query tenant information. An unscoped token along with tenant information can be used to query a scoped token. A scoped token and a service endpoint can be used to authenticate with ECS as described in the previous section describing V1 authentication.

The two articles listed below provide important background information.

-   [OpenStack Keystone Workflow and Token Scoping](http://bodenr.blogspot.com/2014/03/openstack-keystone-workflow-token.html)
-   [Authenticate for Admin API](http://docs.openstack.org/api/openstack-identity-service/2.0/content/POST_authenticate_v2.0_tokens_.html)

### Procedure

1.  Retrieve an unscoped token.

            curl -v -X POST -H 'ACCEPT: application/json' -H "Content-Type: application/json" -d '{"auth":
            {"passwordCredentials" : {"username" : "swift_user", "password" : "123"}}}' http://203.0.113.10:9024/v2.0/tokens


    The response looks like the following. The unscoped token is preceded by id.

            {"access": {"token": {"id":"d668b72a011c4edf960324ab2e87438b","expires":"1376633127950"l},"user":
                             {"name": "sysadmin", "roles":[ ], "role_links":[ ] },"serviceCatalog":[ ] }} , }


2.  Retrieve tenant info associated with the unscoped token.

            curl -v http://203.0.113.10:9024/v2.0/tenants -H 'X-Auth-Token: d668b72a011c4edf960324ab2e87438b'


    The response looks like the following.

            {"tenants_links":[], "tenants":[{"description":"s3","enabled":true, "name": "s3"}]}



3.  Retrieve scoped token along with storageUrl.

            curl -v -X POST -H 'ACCEPT: application/json' -H "Content-Type: application/json" -d '{"auth":      {"tenantName" : "s3",
                              "token":{"id" : d668b72a011c4edf960324ab2e87438b"}}}' http://203.0.113.10:9024/v2.0/tokens


    An example response follows. The scoped token is preceded by id.

            {"access":{"token":{"id":"baf0709e30ed4b138c5db6767ba76a4e
            ","expires":"1376633255485","tenant":{"description":"s3","enabled":true,"name":"s3"}},
            "user":{"name":"swift_admin","roles":[{"name":"member"},{"name":"admin"}],"role_links":[]},
                  "serviceCatalog":[{"type":"object-store", "name":"Swift","endpoints_links":[],"endpoint":[{"internalURL":
                   "http://203.0.113.10:9024/v1/s3","publicURL":"http://203.0.113.10:9024/v1/s3"}]}]}}

4.  Use the scoped token and service endpoint URL for swift authentication. This step is the same as in V1 of OpenStack.

            curl -v -H "X-Auth-Token: baf0709e30ed4b138c5db6767ba76a4e" http://203.0.113.10:9024/v1/s3/{container}/{object}


## Authorization on Container

OpenStack Swift authorization targets only containers.

Swift currently supports two types of authorization:

-   Referral style authorization
-   Group style authorization.

ECS 2.0 supports only group-based authorization.

Admin users can perform all operations within the account. Non-admin users can only perform operations per container based on the container's X-Container-Read and X-Container-Write Access Control Lists. The following operations can be granted to non-admin users:

#### Admin assigns read access to the container

        curl -XPUT -v -H 'X-Container-Read: {GROUP LIST}'
                         -H 'X-Auth-Token: {TOKEN}'
                         http://127.0.0.1:8080/v1/AUTH_bourne/{container1}"


This command allows users belonging to the GROUP LIST to have read access rights to container1.

After read permission is granted, users belongs to target group(s) can perform below operations:

-   HEAD container - Retrieve container metadata. Only allowed if user is assigned to group that has Tenant Administrator privileges.
-   GET container - List objects within a container
-   GET objects with container - Read contents of the object within the container

#### Admin assigns write access to the container

        curl -XPUT -v -H 'X-Container-Write: {GROUP LIST}'
                         -H 'X-Auth-Token: {TOKEN}'
                         http://127.0.0.1:8080/v1/AUTH_bourne/{container1}"


The users in the group GROUP LIST are granted write permission. Once write permission is granted, users belongs to target group(s) can perform following operations:

-   POST container - Set metadata. Start with prefix "X-Container-Meta".
-   PUT objects within container - Write/override objects with container.

Additional information on authorization can be found in: [Container Operations](http://ceph.com/docs/master/radosgw/swift/containerops/)


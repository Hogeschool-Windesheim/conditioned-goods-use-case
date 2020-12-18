#!/bin/bash

spark_company=spark
spark_msp_id=$spark_company
docker_orderer0="orderer0-"$spark_company
docker_orderer1="orderer1-"$spark_company
docker_orderer2="orderer2-"$spark_company

vebabox_company=vebabox
vebabox_msp_id=$vebabox_company

profile_name=SparkVebaboxChannel


# Downloads the binary files and config files for osnadmin and configtx.yaml
cd ~/Downloads
wget https://github.com/hyperledger/fabric/releases/download/v2.3.0/hyperledger-fabric-linux-amd64-2.3.0.tar.gz
tar -xzf hyperledger-fabric-linux-amd64-2.3.0.tar.gz

# We copied the configtx.yaml to the home folder
export FABRIC_CFG_PATH=~/

cat << EOT >> ~/configtx.yaml
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

---
################################################################################
#
#   ORGANIZATIONS
#
#   This section defines the organizational identities that can be referenced
#   in the configuration profiles.
#
################################################################################
Organizations:

    # SampleOrg defines an MSP using the sampleconfig. It should never be used
    # in production but may be used as a template for other definitions.
    - &$spark_company
        # Name is the key by which this org will be referenced in channel
        # configuration transactions.
        # Name can include alphanumeric characters as well as dots and dashes.
        Name: $spark_company

        # SkipAsForeign can be set to true for org definitions which are to be
        # inherited from the orderer system channel during channel creation.  This
        # is especially useful when an admin of a single org without access to the
        # MSP directories of the other orgs wishes to create a channel.  Note
        # this property must always be set to false for orgs included in block
        # creation.
        SkipAsForeign: false

        # ID is the key by which this org's MSP definition will be referenced.
        # ID can include alphanumeric characters as well as dots and dashes.
        ID: $spark_msp_id

        # MSPDir is the filesystem path which contains the MSP configuration.
        MSPDir: organizations/peerOrganizations/$spark_company/msp

        # Policies defines the set of policies at this level of the config tree
        # For organization policies, their canonical path is usually
        #   /Channel/<Application|Orderer>/<OrgName>/<PolicyName>
        Policies: &$spark_company-Policies
            Readers:
                Type: Signature
                Rule: "OR('$spark_company.member')"
                # If your MSP is configured with the new NodeOUs, you might
                # want to use a more specific rule like the following:
                # Rule: "OR('SampleOrg.admin', 'SampleOrg.peer', 'SampleOrg.client')"
            Writers:
                Type: Signature
                Rule: "OR('$spark_company.member')"
                # If your MSP is configured with the new NodeOUs, you might
                # want to use a more specific rule like the following:
                # Rule: "OR('SampleOrg.admin', 'SampleOrg.client')"
            Admins:
                Type: Signature
                Rule: "OR('$spark_company.admin')"
            Endorsement:
                Type: Signature
                Rule: "OR('$spark_company.member')"

        # OrdererEndpoints is a list of all orderers this org runs which clients
        # and peers may to connect to to push transactions and receive blocks respectively.
        OrdererEndpoints:
            - "localhost:7040"
            - "localhost:7041"
            - "localhost:7042"

        # AnchorPeers defines the location of peers which can be used for
        # cross-org gossip communication. Note, this value is only encoded in
        # the genesis block in the Application section context.
        AnchorPeers:
            - Host: localhost
              Port: 7061


    - &$vebabox_company
        # Name is the key by which this org will be referenced in channel
        # configuration transactions.
        # Name can include alphanumeric characters as well as dots and dashes.
        Name: $vebabox_company

        # SkipAsForeign can be set to true for org definitions which are to be
        # inherited from the orderer system channel during channel creation.  This
        # is especially useful when an admin of a single org without access to the
        # MSP directories of the other orgs wishes to create a channel.  Note
        # this property must always be set to false for orgs included in block
        # creation.
        SkipAsForeign: false

        # ID is the key by which this org's MSP definition will be referenced.
        # ID can include alphanumeric characters as well as dots and dashes.
        ID: $vebabox_msp_id

        # MSPDir is the filesystem path which contains the MSP configuration.
        MSPDir: organizations/peerOrganizations/$vebabox_company/msp

        # Policies defines the set of policies at this level of the config tree
        # For organization policies, their canonical path is usually
        #   /Channel/<Application|Orderer>/<OrgName>/<PolicyName>
        Policies: &$vebabox_company-Policies
            Readers:
                Type: Signature
                Rule: "OR('$vebabox_company.member')"
                # If your MSP is configured with the new NodeOUs, you might
                # want to use a more specific rule like the following:
                # Rule: "OR('SampleOrg.admin', 'SampleOrg.peer', 'SampleOrg.client')"
            Writers:
                Type: Signature
                Rule: "OR('$vebabox_company.member')"
                # If your MSP is configured with the new NodeOUs, you might
                # want to use a more specific rule like the following:
                # Rule: "OR('SampleOrg.admin', 'SampleOrg.client')"
            Admins:
                Type: Signature
                Rule: "OR('$vebabox_company.admin')"
            Endorsement:
                Type: Signature
                Rule: "OR('$vebabox_company.member')"

        # OrdererEndpoints is a list of all orderers this org runs which clients
        # and peers may to connect to to push transactions and receive blocks respectively.
#        OrdererEndpoints:
#            - "localhost:8040"

        # AnchorPeers defines the location of peers which can be used for
        # cross-org gossip communication. Note, this value is only encoded in
        # the genesis block in the Application section context.
        AnchorPeers:
            - Host: 192.168.0.87
              Port: 7061


################################################################################
#
#   CAPABILITIES
#
#   This section defines the capabilities of fabric network. This is a new
#   concept as of v1.1.0 and should not be utilized in mixed networks with
#   v1.0.x peers and orderers.  Capabilities define features which must be
#   present in a fabric binary for that binary to safely participate in the
#   fabric network.  For instance, if a new MSP type is added, newer binaries
#   might recognize and validate the signatures from this type, while older
#   binaries without this support would be unable to validate those
#   transactions.  This could lead to different versions of the fabric binaries
#   having different world states.  Instead, defining a capability for a channel
#   informs those binaries without this capability that they must cease
#   processing transactions until they have been upgraded.  For v1.0.x if any
#   capabilities are defined (including a map with all capabilities turned off)
#   then the v1.0.x peer will deliberately crash.
#
################################################################################
Capabilities:
    # Channel capabilities apply to both the orderers and the peers and must be
    # supported by both.
    # Set the value of the capability to true to require it.
    Channel: &ChannelCapabilities
        # V2.0 for Channel is a catchall flag for behavior which has been
        # determined to be desired for all orderers and peers running at the v2.0.0
        # level, but which would be incompatible with orderers and peers from
        # prior releases.
        # Prior to enabling V2.0 channel capabilities, ensure that all
        # orderers and peers on a channel are at v2.0.0 or later.
        V2_0: true

    # Orderer capabilities apply only to the orderers, and may be safely
    # used with prior release peers.
    # Set the value of the capability to true to require it.
    Orderer: &OrdererCapabilities
        # V1.1 for Orderer is a catchall flag for behavior which has been
        # determined to be desired for all orderers running at the v1.1.x
        # level, but which would be incompatible with orderers from prior releases.
        # Prior to enabling V2.0 orderer capabilities, ensure that all
        # orderers on a channel are at v2.0.0 or later.
        V2_0: true

    # Application capabilities apply only to the peer network, and may be safely
    # used with prior release orderers.
    # Set the value of the capability to true to require it.
    Application: &ApplicationCapabilities
        # V2.0 for Application enables the new non-backwards compatible
        # features and fixes of fabric v2.0.
        # Prior to enabling V2.0 orderer capabilities, ensure that all
        # orderers on a channel are at v2.0.0 or later.
        V2_0: true

################################################################################
#
#   APPLICATION
#
#   This section defines the values to encode into a config transaction or
#   genesis block for application-related parameters.
#
################################################################################
Application: &ApplicationDefaults
    ACLs: &ACLsDefault
        # This section provides defaults for policies for various resources
        # in the system. These "resources" could be functions on system chaincodes
        # (e.g., "GetBlockByNumber" on the "qscc" system chaincode) or other resources
        # (e.g.,who can receive Block events). This section does NOT specify the resource's
        # definition or API, but just the ACL policy for it.
        #
        # Users can override these defaults with their own policy mapping by defining the
        # mapping under ACLs in their channel definition

        #---New Lifecycle System Chaincode (_lifecycle) function to policy mapping for access control--#

        # ACL policy for _lifecycle's "CheckCommitReadiness" function
        _lifecycle/CheckCommitReadiness: /Channel/Application/Writers

        # ACL policy for _lifecycle's "CommitChaincodeDefinition" function
        _lifecycle/CommitChaincodeDefinition: /Channel/Application/Writers

        # ACL policy for _lifecycle's "QueryChaincodeDefinition" function
        _lifecycle/QueryChaincodeDefinition: /Channel/Application/Writers

        # ACL policy for _lifecycle's "QueryChaincodeDefinitions" function
        _lifecycle/QueryChaincodeDefinitions: /Channel/Application/Writers

        #---Lifecycle System Chaincode (lscc) function to policy mapping for access control---#

        # ACL policy for lscc's "getid" function
        lscc/ChaincodeExists: /Channel/Application/Readers

        # ACL policy for lscc's "getdepspec" function
        lscc/GetDeploymentSpec: /Channel/Application/Readers

        # ACL policy for lscc's "getccdata" function
        lscc/GetChaincodeData: /Channel/Application/Readers

        # ACL Policy for lscc's "getchaincodes" function
        lscc/GetInstantiatedChaincodes: /Channel/Application/Readers

        #---Query System Chaincode (qscc) function to policy mapping for access control---#

        # ACL policy for qscc's "GetChainInfo" function
        qscc/GetChainInfo: /Channel/Application/Readers

        # ACL policy for qscc's "GetBlockByNumber" function
        qscc/GetBlockByNumber: /Channel/Application/Readers

        # ACL policy for qscc's  "GetBlockByHash" function
        qscc/GetBlockByHash: /Channel/Application/Readers

        # ACL policy for qscc's "GetTransactionByID" function
        qscc/GetTransactionByID: /Channel/Application/Readers

        # ACL policy for qscc's "GetBlockByTxID" function
        qscc/GetBlockByTxID: /Channel/Application/Readers

        #---Configuration System Chaincode (cscc) function to policy mapping for access control---#

        # ACL policy for cscc's "GetConfigBlock" function
        cscc/GetConfigBlock: /Channel/Application/Readers

        # ACL policy for cscc's "GetChannelConfig" function
        cscc/GetChannelConfig: /Channel/Application/Readers

        #---Miscellaneous peer function to policy mapping for access control---#

        # ACL policy for invoking chaincodes on peer
        peer/Propose: /Channel/Application/Writers

        # ACL policy for chaincode to chaincode invocation
        peer/ChaincodeToChaincode: /Channel/Application/Writers

        #---Events resource to policy mapping for access control###---#

        # ACL policy for sending block events
        event/Block: /Channel/Application/Readers

        # ACL policy for sending filtered block events
        event/FilteredBlock: /Channel/Application/Readers

    # Organizations lists the orgs participating on the application side of the
    # network.
    Organizations:

    # Policies defines the set of policies at this level of the config tree
    # For Application policies, their canonical path is
    #   /Channel/Application/<PolicyName>
    Policies: &ApplicationDefaultPolicies
        LifecycleEndorsement:
            Type: ImplicitMeta
            Rule: "MAJORITY Endorsement"
        Endorsement:
            Type: ImplicitMeta
            Rule: "MAJORITY Endorsement"
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"

    # Capabilities describes the application level capabilities, see the
    # dedicated Capabilities section elsewhere in this file for a full
    # description
    Capabilities:
        <<: *ApplicationCapabilities

################################################################################
#
#   ORDERER
#
#   This section defines the values to encode into a config transaction or
#   genesis block for orderer related parameters.
#
################################################################################
Orderer: &OrdererDefaults

    # Orderer Type: The orderer implementation to start.
    # Available types are "solo", "kafka" and "etcdraft".
    OrdererType: etcdraft

    # Addresses used to be the list of orderer addresses that clients and peers
    # could connect to.  However, this does not allow clients to associate orderer
    # addresses and orderer organizations which can be useful for things such
    # as TLS validation.  The preferred way to specify orderer addresses is now
    # to include the OrdererEndpoints item in your org definition
    Addresses:
        # - 127.0.0.1:7050

    # Batch Timeout: The amount of time to wait before creating a batch.
    BatchTimeout: 2s

    # Batch Size: Controls the number of messages batched into a block.
    # The orderer views messages opaquely, but typically, messages may
    # be considered to be Fabric transactions.  The 'batch' is the group
    # of messages in the 'data' field of the block.  Blocks will be a few kb
    # larger than the batch size, when signatures, hashes, and other metadata
    # is applied.
    BatchSize:

        # Max Message Count: The maximum number of messages to permit in a
        # batch.  No block will contain more than this number of messages.
        MaxMessageCount: 500

        # Absolute Max Bytes: The absolute maximum number of bytes allowed for
        # the serialized messages in a batch. The maximum block size is this value
        # plus the size of the associated metadata (usually a few KB depending
        # upon the size of the signing identities). Any transaction larger than
        # this value will be rejected by ordering. If the "kafka" OrdererType is
        # selected, set 'message.max.bytes' and 'replica.fetch.max.bytes' on
        # the Kafka brokers to a value that is larger than this one.
        AbsoluteMaxBytes: 10 MB

        # Preferred Max Bytes: The preferred maximum number of bytes allowed
        # for the serialized messages in a batch. Roughly, this field may be considered
        # the best effort maximum size of a batch. A batch will fill with messages
        # until this size is reached (or the max message count, or batch timeout is
        # exceeded).  If adding a new message to the batch would cause the batch to
        # exceed the preferred max bytes, then the current batch is closed and written
        # to a block, and a new batch containing the new message is created.  If a
        # message larger than the preferred max bytes is received, then its batch
        # will contain only that message.  Because messages may be larger than
        # preferred max bytes (up to AbsoluteMaxBytes), some batches may exceed
        # the preferred max bytes, but will always contain exactly one transaction.
        PreferredMaxBytes: 2 MB

    # Max Channels is the maximum number of channels to allow on the ordering
    # network. When set to 0, this implies no maximum number of channels.
    MaxChannels: 0

    Kafka:
        # Brokers: A list of Kafka brokers to which the orderer connects. Edit
        # this list to identify the brokers of the ordering service.
        # NOTE: Use IP:port notation.
        Brokers:
            - kafka0:9092
            - kafka1:9092
            - kafka2:9092

    # EtcdRaft defines configuration which must be set when the "etcdraft"
    # orderertype is chosen.
    EtcdRaft:
        # The set of Raft replicas for this network. For the etcd/raft-based
        # implementation, we expect every replica to also be an OSN. Therefore,
        # a subset of the host:port items enumerated in this list should be
        # replicated under the Orderer.Addresses key above.
        Consenters:
            - Host: localhost
              Port: 7040
              ClientTLSCert: organizations/peerOrganizations/$spark_company/peers/$docker_orderer0/tls/cert.pem
              ServerTLSCert: organizations/peerOrganizations/$spark_company/peers/$docker_orderer0/tls/cert.pem
            - Host: localhost
              Port: 7041
              ClientTLSCert: organizations/peerOrganizations/$spark_company/peers/$docker_orderer1/tls/cert.pem
              ServerTLSCert: organizations/peerOrganizations/$spark_company/peers/$docker_orderer1/tls/cert.pem
            - Host: localhost
              Port: 7042
              ClientTLSCert: organizations/peerOrganizations/$spark_company/peers/$docker_orderer2/tls/cert.pem
              ServerTLSCert: organizations/peerOrganizations/$spark_company/peers/$docker_orderer2/tls/cert.pem


        # Options to be specified for all the etcd/raft nodes. The values here
        # are the defaults for all new channels and can be modified on a
        # per-channel basis via configuration updates.
        Options:
            # TickInterval is the time interval between two Node.Tick invocations.
            TickInterval: 500ms

            # ElectionTick is the number of Node.Tick invocations that must pass
            # between elections. That is, if a follower does not receive any
            # message from the leader of current term before ElectionTick has
            # elapsed, it will become candidate and start an election.
            # ElectionTick must be greater than HeartbeatTick.
            ElectionTick: 10

            # HeartbeatTick is the number of Node.Tick invocations that must
            # pass between heartbeats. That is, a leader sends heartbeat
            # messages to maintain its leadership every HeartbeatTick ticks.
            HeartbeatTick: 1

            # MaxInflightBlocks limits the max number of in-flight append messages
            # during optimistic replication phase.
            MaxInflightBlocks: 5

            # SnapshotIntervalSize defines number of bytes per which a snapshot is taken
            SnapshotIntervalSize: 16 MB

    # Organizations lists the orgs participating on the orderer side of the
    # network.
    Organizations:

    # Policies defines the set of policies at this level of the config tree
    # For Orderer policies, their canonical path is
    #   /Channel/Orderer/<PolicyName>
    Policies:
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"
        # BlockValidation specifies what signatures must be included in the block
        # from the orderer for the peer to validate it.
        BlockValidation:
            Type: ImplicitMeta
            Rule: "ANY Writers"

    # Capabilities describes the orderer level capabilities, see the
    # dedicated Capabilities section elsewhere in this file for a full
    # description
    Capabilities:
        <<: *OrdererCapabilities

################################################################################
#
#   CHANNEL
#
#   This section defines the values to encode into a config transaction or
#   genesis block for channel related parameters.
#
################################################################################
Channel: &ChannelDefaults
    # Policies defines the set of policies at this level of the config tree
    # For Channel policies, their canonical path is
    #   /Channel/<PolicyName>
    Policies:
        # Who may invoke the 'Deliver' API
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        # Who may invoke the 'Broadcast' API
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        # By default, who may modify elements at this config level
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"


    # Capabilities describes the channel level capabilities, see the
    # dedicated Capabilities section elsewhere in this file for a full
    # description
    Capabilities:
        <<: *ChannelCapabilities

################################################################################
#
#   PROFILES
#
#   Different configuration profiles may be encoded here to be specified as
#   parameters to the configtxgen tool. The profiles which specify consortiums
#   are to be used for generating the orderer genesis block. With the correct
#   consortium members defined in the orderer genesis block, channel creation
#   requests may be generated with only the org member names and a consortium
#   name.
#
################################################################################
Profiles:

    # SampleAppChannelEtcdRaft defines an application channel configuration
    # that uses the etcd/raft-based orderer.
    SampleAppChannelEtcdRaft:
        <<: *ChannelDefaults
        Orderer:
            <<: *OrdererDefaults
            OrdererType: etcdraft
            Organizations:
                - <<: *$spark_company
                  Policies:
                      <<: *$spark_company-Policies
                      Admins:
                          Type: Signature
                          Rule: "OR('$spark_company.member')"
        Application:
            <<: *ApplicationDefaults
            Organizations:
                - <<: *$spark_company
                  Policies:
                      <<: *$spark_company-Policies
                      Admins:
                          Type: Signature
                          Rule: "OR('$spark_company.member')"
EOT

# configtx.yaml aanpassen volgens: https://hyperledger-fabric.readthedocs.io/en/latest/create_channel/create_channel_participation.html#the-configtx-yaml-file
cd ~/Downloads/bin
./configtxgen -profile SampleAppChannelEtcdRaft -outputBlock genesis_block.pb -channelID spark-vebabox-channel

export OSN_TLS_CA_ROOT_CERT=~/organizations/peerOrganizations/$spark_company/peers/orderer0-spark/tls/tls-ca-cert.pem
export ADMIN_TLS_SIGN_CERT=~/admin-client/admin-client-tls-cert.pem
export ADMIN_TLS_PRIVATE_KEY=~/admin-client/admin-client-tls-key.pem

./osnadmin channel join --channel-id spark-vebabox-channel  --config-block ~/Downloads/bin/genesis_block.pb -o localhost:9440 --ca-file $OSN_TLS_CA_ROOT_CERT --client-cert $ADMIN_TLS_SIGN_CERT --client-key $ADMIN_TLS_PRIVATE_KEY
./osnadmin channel join --channel-id spark-vebabox-channel  --config-block ~/Downloads/bin/genesis_block.pb -o localhost:9441 --ca-file $OSN_TLS_CA_ROOT_CERT --client-cert $ADMIN_TLS_SIGN_CERT --client-key $ADMIN_TLS_PRIVATE_KEY
./osnadmin channel join --channel-id spark-vebabox-channel  --config-block ~/Downloads/bin/genesis_block.pb -o localhost:9442 --ca-file $OSN_TLS_CA_ROOT_CERT --client-cert $ADMIN_TLS_SIGN_CERT --client-key $ADMIN_TLS_PRIVATE_KEY


#./osnadmin channel list -c spark-vebabox-channel -o localhost:9440 --ca-file ~/organizations/peerOrganizations/spark/peers/orderer0-spark/tls/tls-ca-cert.pem --client-cert ~/admin-client/admin-client-tls-cert.pem --client-key ~/admin-client/admin-client-tls-key.pem
#./osnadmin channel list -c spark-vebabox-channel -o localhost:9441 --ca-file ~/organizations/peerOrganizations/spark/peers/orderer1-spark/tls/tls-ca-cert.pem --client-cert ~/admin-client/admin-client-tls-cert.pem --client-key ~/admin-client/admin-client-tls-key.pem
#./osnadmin channel list -c spark-vebabox-channel -o localhost:9442 --ca-file ~/organizations/peerOrganizations/spark/peers/orderer2-spark/tls/tls-ca-cert.pem --client-cert ~/admin-client/admin-client-tls-cert.pem --client-key ~/admin-client/admin-client-tls-key.pem

# Command below dependend on the exports for the variables
#export ORDERER_CAFILE=/etc/hyperledger/fabric/tls/tls-ca-cert.pem
#export TLS_CERTFILE=/etc/hyperledger/fabric/tls/cert.pem
#export ADMIN_TLS_PRIVATE_KEY=/etc/hyperledger/fabric/tls/key.pem

cd
#docker exec -it peer0-spark peer channel fetch newest /etc/hyperledger/fabric/production/mychannel.block -c spark-vebabox-channel -o localhost:9440 --cafile /etc/hyperledger/fabric/tls/tls-ca-cert.pem --certfile /etc/hyperledger/fabric/tls/cert.pem --keyfile /etc/hyperledger/fabric/tls/key.pem
sudo cp ~/Downloads/bin/genesis_block.pb ~/container-volumes/peer0-spark/production
docker exec -it peer0-spark peer channel join -b /var/hyperledger/production/genesis_block.pb -o VebaBox-Node:9440 --clientauth --cafile /etc/hyperledger/fabric/msp/tls/tls-ca-cert.pem --certfile /etc/hyperledger/fabric/msp/user/peer-admin/tls/cert.pem --keyfile /etc/hyperledger/fabric/msp/user/peer-admin/tls/key.pem

#export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/user/peer-admin/msp

#./osnadmin channel join --channel-id spark-vebabox-channel  --config-block ~/Downloads/bin/genesis_block.pb -o localhost:9440 --ca-file ~/organizations/peerOrganizations/spark/peers/orderer0-spark/tls/tls-ca-cert.pem --client-cert ~/admin-client/admin-client-tls-cert.pem --client-key ~/admin-client/admin-client-tls-key.pem
#docker exec -it peer0-spark peer channel join -b ~/Downloads/bin/genesis_block.pb -o VebaBox-Node:9440 --clientauth --cafile ~/organizations/peerOrganizations/spark/peers/orderer0-spark/tls/tls-ca-cert.pem --client-cert ~/admin-client/admin-client-tls-cert.pem --client-key ~/admin-client/admin-client-tls-key.pem
# docker exec -it peer0-spark peer channel join -b /var/hyperledger/production/genesis_block.pb -o VebaBox-Node:9440 --clientauth --cafile /etc/hyperledger/fabric/production/localhost-7055.pem --certfile /etc/hyperledger/fabric/msp/user/peer-admin/tls/cert.pem --keyfile /etc/hyperledger/fabric/msp/user/peer-admin/tls/key.pem
#!/bin/sh
export PACKAGEID="Carshowroom_1:8eb88e7c2bca5d3d9f3b8b7c7d92617cda7115ebeefc9c58666207582617a1d5"
echo $PACKAGEID
source ./lifecycle_setup_org1.sh
peer lifecycle chaincode getinstalledpackage --package-id $PACKAGEID --output-directory . --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
peer lifecycle chaincode queryinstalled --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA -C samplechannel --name Carshowroom --version 1.0 --init-required --package-id $PACKAGEID --sequence 1 
source ./lifecycle_setup_org2.sh
peer lifecycle chaincode queryinstalled --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA -C samplechannel --name Carshowroom --version 1.0 --init-required --package-id $PACKAGEID --sequence 1 
source ./lifecycle_setup_org1.sh
peer lifecycle chaincode checkcommitreadiness -C samplechannel --name Carshowroom --version 1.0 --sequence 1 --output json --init-required
source ./lifecycle_setup_org2.sh
peer lifecycle chaincode checkcommitreadiness -C samplechannel --name Carshowroom --version 1.0 --sequence 1 --output json --init-required
source ./lifecycle_setup_Channel_commit.sh
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C samplechannel --name Carshowroom --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE_ORG1 --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE_ORG2 --version 1.0 --sequence 1 --init-required
peer lifecycle chaincode querycommitted -C samplechannel --name Carshowroom
source ./lifecycle_setup_org1.sh
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C samplechannel -n Carshowroom --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE_ORG1 --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE_ORG2 --isInit -c '{"Args":[]}'
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C samplechannel -n Carshowroom --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE_ORG1 --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE_ORG2 -c '{"Args":["addNewCar", "2", "Ford","John","1000"]}'
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C samplechannel -n Carshowroom --peerAddresses localhost:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE_ORG1 --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE_ORG2 -c '{"Args":["queryCarById", "2"]}'
